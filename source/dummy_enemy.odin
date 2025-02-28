package game

import rl "vendor:raylib"
import  "core:fmt"
import "core:math"
import "core:encoding/uuid"
import "core:crypto"


ENEMY_SPEED : f32 : 100
SPACE_BETWEEN_OTHERS : f32 : 20
DISTANCE_TO_PLAYER : f32 : 10
DummyEnemy :: struct {
    position : rl.Vector2,
    id : uuid.Identifier
}

dummy_enemy_make :: proc () -> ^DummyEnemy {
    result := new(DummyEnemy)
    result.position = rl.Vector2{f32(rl.GetRandomValue(0,800)), f32(rl.GetRandomValue(0,450))}
    result.id = entity_generate_id()
    return result
}

entity_generate_id :: proc() -> uuid.Identifier {
    context.random_generator = crypto.random_generator()
    return uuid.generate_v7()
}

dummy_enemy_draw :: proc (enemy : ^DummyEnemy, other_enemies : []^DummyEnemy, debug_mode : bool = false) {
    rl.DrawCircle(i32(enemy.position.x), i32(enemy.position.y), 10, rl.YELLOW)
    rl.DrawCircleLines(i32(enemy.position.x), i32(enemy.position.y), SPACE_BETWEEN_OTHERS, rl.RED)
    if debug_mode {
        for &other_enemy in other_enemies {
            if (other_enemy.id == enemy.id) {
                continue
            }
            color := rl.GREEN
            if rl.Vector2DistanceSqrt(enemy.position, other_enemy.position) < math.pow(SPACE_BETWEEN_OTHERS*2+10,2) {
                color = rl.RED
            }
            rl.DrawLine(i32(enemy.position.x), i32(enemy.position.y), i32(other_enemy.position.x), i32(other_enemy.position.y), color)
        }
    }
}

dummy_enemy_move_towards_direction :: proc (enemy : ^DummyEnemy, direction : rl.Vector2, dt : f32) {
    enemy.position += direction * ENEMY_SPEED * dt
}

dummy_enemy_separate :: proc (enemy : ^DummyEnemy, enemies : []^DummyEnemy, dt : f32) {
    others_to_avoid : int = 0
    separation_velocity := rl.Vector2{0,0}
    for &other_enemy in enemies {
        if (other_enemy.id == enemy.id) {
            continue
        }
        dist := rl.Vector2DistanceSqrt(enemy.position,other_enemy.position)
        dist_to_compare := math.pow(10+SPACE_BETWEEN_OTHERS*2,2)
        if dist > 0 && dist < dist_to_compare {
            fmt.println("SEPARATE BRO PLIS",)
            direction := enemy.position - other_enemy.position
            // direction = direction * dt * ENEMY_SPEED
            direction = rl.Vector2Normalize(direction)
            weighted_vel := direction / dist
            separation_velocity += weighted_vel
            others_to_avoid += 1
            
            // dummy_enemy_move_towards_direction(enemy, direction, dt)
        }
    }
    if others_to_avoid > 0 {
        separation_velocity = separation_velocity / f32(others_to_avoid)
        separation_velocity = rl.Vector2Normalize(separation_velocity)
        dummy_enemy_move_towards_direction(enemy, separation_velocity, dt)
    }
}

enemy_is_close_enough :: proc (enemy : ^DummyEnemy, player : ^DummyPlayer) -> bool {
    return rl.Vector2Distance(enemy.position, player.position) < SPACE_BETWEEN_OTHERS
}