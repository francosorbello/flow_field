package game

import rl "vendor:raylib"
import  "core:fmt"
ENEMY_SPEED : f32 : 100
SPACE_BETWEEN_OTHERS : f32 : 64
DummyEnemy :: struct {
    position : rl.Vector2,
}

dummy_enemy_make :: proc () -> ^DummyEnemy {
    result := new(DummyEnemy)
    result.position = rl.Vector2{f32(rl.GetRandomValue(0,800)), f32(rl.GetRandomValue(0,450))}
    return result
}

dummy_enemy_draw :: proc (enemy : ^DummyEnemy) {
    rl.DrawCircle(i32(enemy.position.x), i32(enemy.position.y), 10, rl.RED)
}

dummy_enemy_move_towards_direction :: proc (enemy : ^DummyEnemy, direction : rl.Vector2, dt : f32) {
    enemy.position += direction * ENEMY_SPEED * dt
}

dummy_enemy_separate :: proc (enemy : ^DummyEnemy, enemies : []^DummyEnemy, dt : f32) {
    others_to_avoid : int = 0
    separation_velocity := rl.Vector2{0,0}
    for &other_enemy in enemies {
        if (other_enemy == enemy) {
            continue
        }
        dist := rl.Vector2Distance(other_enemy.position,enemy.position)
        if dist > 0 && dist < SPACE_BETWEEN_OTHERS {
            direction := enemy.position - other_enemy.position
            direction = direction * dt
            direction = rl.Vector2Normalize(direction)
            weighted_vel := direction / dist
            separation_velocity += weighted_vel
            others_to_avoid += 1
            // dummy_enemy_move_towards_direction(enemy, direction, dt)
        }
    }
    if others_to_avoid > 0 {
        separation_velocity = separation_velocity / f32(others_to_avoid)
        // separation_velocity = rl.Vector2Normalize(separation_velocity)
        separation_velocity *= 1
        fmt.println(separation_velocity)
        dummy_enemy_move_towards_direction(enemy, separation_velocity, dt)
    }
}