package game

import rl "vendor:raylib"
import "core:log"
import "core:c"
import ff "flow_field"

ENEMY_COUNT : int : 2

run: bool
grid : ^ff.FFGrid
player : ^DummyPlayer

enemies : [ENEMY_COUNT]^DummyEnemy

init :: proc() {
	run = true
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")
	grid = ff.ff_grid_make()
	ff.ff_grid_add_vertical_wall(grid, 10, 0, 10)
	player = dummy_player_make()
	
	for i in 0..<len(enemies) {
		enemies[i] = dummy_enemy_make()
	}
}

update :: proc() {
	
	// Update player
	dt := rl.GetFrameTime()
	dummy_player_update(player, dt)

	target_tile := ff.ff_grid_world_pos_to_index(grid, int(player.position.x), int(player.position.y))
	distances,calc_ok := ff.ff_pathfinder_calculate(grid, grid.tiles[target_tile])
	flows := ff.ff_pathfinder_cost_field_to_flow_field(grid, distances, target_tile)

	if(calc_ok) {
		for enemy in enemies {
			if (!enemy_is_close_enough(enemy, player)) {
				enemy_pos_index := ff.ff_grid_world_pos_to_index(grid, int(enemy.position.x), int(enemy.position.y))
				
				if (enemy_pos_index < 0 || enemy_pos_index >= len(flows)) {
					log.error("Enemy out of bounds")
					continue
				}
				dummy_enemy_move_towards_direction(enemy, flows[ff.ff_grid_world_pos_to_index(grid, int(enemy.position.x), int(enemy.position.y))], dt)
			}
			dummy_enemy_separate(enemy, enemies[:], dt)
		}
	}

	rl.BeginDrawing()
	rl.ClearBackground({0, 120, 153, 255})
	
	// ff_visualizer_draw_cost(grid, target_tile, distances, calc_ok)
	ff.ff_visualizer_draw_flow(grid, target_tile, flows[:], calc_ok)

	dummy_player_draw(player)
	for enemy in enemies {
		dummy_enemy_draw(enemy, enemies[:], true)
	}


	
	rl.EndDrawing()
	// Anything allocated using temp allocator is invalid after this.
	free_all(context.temp_allocator)
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
	ff.ff_grid_free(grid)
	dummy_player_free(player)
	for enemy in enemies {
		dummy_enemy_free(enemy)
	}
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}