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
	distances := ff_pathfinder_calculate(grid, grid.tiles[target_tile])

	i := 0
	for tile in tiles {
		pos_x := i32(tile.x * grid.tile_size)
		pos_y := i32(tile.y * grid.tile_size)
		tile_size := i32(grid.tile_size)
		tile_color := rl.Color{255, 255, 255, 255}
		if tile.type == TileType.Wall {
			tile_color = rl.Color{0, 0, 0, 255}
		}
		if i == target_tile {
			tile_color = rl.Color{255, 0, 0, 255}
		}
		rl.DrawRectangle(pos_x, pos_y, tile_size, tile_size, tile_color)
		rl.DrawRectangleLines(pos_x, pos_y, tile_size, tile_size, rl.Color{0, 0, 0, 255})
		dist_val := fmt.ctprint(distances[tile])
		
		rl.DrawText(dist_val, pos_x + 5, pos_y + 5, 10, rl.Color{0, 0, 0, 255})
		i += 1
	}
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