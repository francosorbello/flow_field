package game

import rl "vendor:raylib"

PLAYER_SPEED : f32 : 100

DummyPlayer :: struct {
    position : rl.Vector2,
}

dummy_player_make :: proc () -> ^DummyPlayer {
    result := new(DummyPlayer)
    result^ = {
        position = rl.Vector2{100, 100},
    }
    return result
}

dummy_player_free :: proc (player : ^DummyPlayer) {
    free(player)
}

dummy_player_update :: proc(player : ^DummyPlayer, dt : f32) {
    // Update player
    direction := rl.Vector2{0,0}

    if (rl.IsKeyDown(rl.KeyboardKey.UP)) {direction.y = -1.0}
    if (rl.IsKeyDown(rl.KeyboardKey.DOWN)) {direction.y = 1.0}
    if (rl.IsKeyDown(rl.KeyboardKey.LEFT)) {direction.x = -1.0}
    if (rl.IsKeyDown(rl.KeyboardKey.RIGHT)) {direction.x = 1.0}

    direction = rl.Vector2Normalize(direction)
    new_pos := player.position + direction * PLAYER_SPEED * dt
    
    player.position = new_pos
}

dummy_player_draw :: proc(player : ^DummyPlayer) {
    rl.DrawCircle(i32(player.position.x),i32(player.position.y),10,rl.GREEN)
}