package game

import "core:fmt"
import rl "vendor:raylib"

ff_visualizer_draw :: proc (grid : ^FFGrid,target_index : int, distances : map[FFTile]int, calc_ok : bool) {
    i := 0
    tiles := grid.tiles
    target := grid.tiles[target_index]

	for tile in tiles {
		pos_x := i32(tile.x * grid.tile_size)
		pos_y := i32(tile.y * grid.tile_size)
		tile_size := i32(grid.tile_size)
		tile_color := rl.Color{255, 255, 255, 255}
		if tile.type == TileType.Wall {
			tile_color = rl.Color{0, 0, 0, 255}
		}
		if i == target_index && target.type != TileType.Wall {
			tile_color = rl.Color{255, 0, 0, 255}
		}
		rl.DrawRectangle(pos_x, pos_y, tile_size, tile_size, tile_color)
		rl.DrawRectangleLines(pos_x, pos_y, tile_size, tile_size, rl.Color{0, 0, 0, 255})
        if calc_ok {
            dist_val := fmt.ctprint(distances[tile])
            rl.DrawText(dist_val, pos_x + 5, pos_y + 5, 10, rl.Color{0, 0, 0, 255})
        }
		i += 1
	}
}