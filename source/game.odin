package game

import rl "vendor:raylib"
import "core:log"
import "core:fmt"
import "core:c"

run: bool
grid : ^FFGrid
player : ^DummyPlayer

init :: proc() {
	run = true
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")
	grid = ff_grid_make()
	player = dummy_player_make()
}

update :: proc() {
	
	// Update player
	dt := rl.GetFrameTime()
	dummy_player_update(player, dt)
	
	rl.BeginDrawing()
	rl.ClearBackground({0, 120, 153, 255})
	
	tiles := grid.tiles
	target_tile := ff_grid_world_pos_to_index(grid, int(player.position.x), int(player.position.y))
	distances,calc_ok := ff_pathfinder_calculate(grid, grid.tiles[target_tile])
	flows := ff_pathfinder_cost_field_to_flow_field(grid, distances, target_tile)
	// ff_visualizer_draw_cost(grid, target_tile, distances, calc_ok)
	ff_visualizer_draw_flow(grid, target_tile, flows[:], calc_ok)

	dummy_player_draw(player)
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
	ff_grid_free(grid)
	dummy_player_free(player)
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