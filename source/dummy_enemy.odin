package game

import rl "vendor:raylib"

ENEMY_SPEED : f32 : 100
SPACE_BETWEEN_OTHERS : f32 : 20
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
    for &other_enemy in enemies {
        if (other_enemy == enemy) {
            continue
        }
        if rl.Vector2Distance(other_enemy.position,enemy.position) < SPACE_BETWEEN_OTHERS {
            direction := enemy.position - other_enemy.position
            direction = direction * dt
            
            dummy_enemy_move_towards_direction(enemy, direction, dt)
        }
    }
}