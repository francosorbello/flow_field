package game

import rl "vendor:raylib"
import "core:encoding/uuid"
import "core:crypto"
import "core:math"

ENEMY_SPEED : f32 : 100
SPACE_BETWEEN_OTHERS : f32 : 20
DISTANCE_TO_PLAYER : f32 : 10
DRAW_SMOOTH : f32 : 0.93

DummyEnemy :: struct {
    position : rl.Vector2,
    id : uuid.Identifier,
    draw_position: rl.Vector2,
}

dummy_enemy_make :: proc () -> ^DummyEnemy {
    result := new(DummyEnemy)
    random_pos := rl.Vector2{f32(rl.GetRandomValue(0,800)), f32(rl.GetRandomValue(0,450))}
    result.position = random_pos
    result.draw_position = random_pos
    result.id = entity_generate_id()
    return result
}

entity_generate_id :: proc() -> uuid.Identifier {
    context.random_generator = crypto.random_generator()
    return uuid.generate_v7()
}

dummy_enemy_draw :: proc (enemy : ^DummyEnemy, other_enemies : []^DummyEnemy, debug_mode : bool = false) {
    rl.DrawCircle(i32(enemy.draw_position.x), i32(enemy.draw_position.y), 10, rl.YELLOW)
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
            direction := enemy.position - other_enemy.position
            direction = rl.Vector2Normalize(direction)
            weighted_vel := direction / dist
            separation_velocity += weighted_vel
            others_to_avoid += 1
        }
    }
    if others_to_avoid > 0 {
        separation_velocity = separation_velocity / f32(others_to_avoid)
        separation_velocity = rl.Vector2Normalize(separation_velocity)
        dummy_enemy_move_towards_direction(enemy, separation_velocity, dt)
    }
    enemy.draw_position = enemy.draw_position * DRAW_SMOOTH + enemy.position * (1-DRAW_SMOOTH)
}

enemy_is_close_enough :: proc (enemy : ^DummyEnemy, player : ^DummyPlayer) -> bool {
    return rl.Vector2Distance(enemy.position, player.position) < SPACE_BETWEEN_OTHERS
}

dummy_enemy_free :: proc (enemy : ^DummyEnemy) {
    free(enemy)
}