package flow_field

import "core:fmt"
import rl "vendor:raylib"

DIR_LEFT : rl.Vector2 : rl.Vector2{-1,0}
DIR_RIGTH : rl.Vector2 : rl.Vector2{1,0}
DIR_UP : rl.Vector2 : rl.Vector2{0,-1}
DIR_DOWN : rl.Vector2 : rl.Vector2{0,1}

ff_visualizer_draw_cost :: proc (grid : ^FFGrid,target_index : int, distances : map[FFTile]int, calc_ok : bool) {
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

ff_visualizer_draw_flow :: proc (grid : ^FFGrid,target_index : int, directions : []rl.Vector2, calc_ok : bool) {
    i := 0
    tiles := grid.tiles
    target := grid.tiles[target_index]

	for tile in tiles {
		pos_x := i32(tile.x * grid.tile_size)
		pos_y := i32(tile.y * grid.tile_size)
		tile_size := i32(grid.tile_size)
		tile_color := rl.LIGHTGRAY
		if tile.type == TileType.Wall {
			tile_color = rl.Color{0, 0, 0, 255}
		}
		if i == target_index && target.type != TileType.Wall {
			tile_color = rl.Color{255, 0, 0, 255}
		}
		rl.DrawRectangle(pos_x, pos_y, tile_size, tile_size, tile_color)
		rl.DrawRectangleLines(pos_x, pos_y, tile_size, tile_size, rl.Color{0, 0, 0, 255})
        if calc_ok /*&& i == 216*/ && tile.type != TileType.Wall {
            dir := directions[i]
			modified_dir := dir
			if dir.x == 0 {
				modified_dir *= -1
			}
			modified_dir += rl.Vector2{1,1}
			// fmt.println(dir,dir + rl.Vector2{1,1})
			if dir.x != 0 || dir.y != 0 {
				// v1 := [2]i32{pos_x + (tile_size / 2)*i32(modified_dir.x), pos_y + (tile_size / 2)*i32(modified_dir.y)}
				v1 := [2]i32{}
				v2 := [2]i32{}
				v3 := [2]i32{}

				switch dir {
				case DIR_LEFT:
					// fmt.println("DIR_LEFT")
					v2 = [2]i32{pos_x, pos_y+14}
					v1 = [2]i32{pos_x+16, pos_y+2}
					v3 = [2]i32{pos_x+16, pos_y+30}
				case DIR_RIGTH:
					// fmt.println("DIR_RIGTH")
					v3 = [2]i32{pos_x+30, pos_y+16}
					v1 = [2]i32{pos_x+16, pos_y+2}
					v2 = [2]i32{pos_x+16, pos_y+30}
				case DIR_UP:
					// fmt.println("DIR_UP")
					v2 = [2]i32{pos_x+16, pos_y+2}
					v3 = [2]i32{pos_x+2, pos_y+16}
					v1 = [2]i32{pos_x+30, pos_y+16}
				case DIR_DOWN:
					// fmt.println("DIR_DOWN")
					v2 = [2]i32{pos_x+16, pos_y+30}
					v1 = [2]i32{pos_x+2, pos_y+16}
					v3 = [2]i32{pos_x+30, pos_y+16}
				}
				rl.DrawTriangleLines(
					rl.Vector2{f32(v1[0]), f32(v1[1])},
					rl.Vector2{f32(v2[0]), f32(v2[1])},
					rl.Vector2{f32(v3[0]), f32(v3[1])},
					rl.Color{0, 0, 255, 255},
				)
				rl.DrawTriangle(
					rl.Vector2{f32(v1[0]), f32(v1[1])},
					rl.Vector2{f32(v2[0]), f32(v2[1])},
					rl.Vector2{f32(v3[0]), f32(v3[1])},
					rl.Color{0, 0, 255, 255},
				)
			}
        }
		i += 1
	}
}