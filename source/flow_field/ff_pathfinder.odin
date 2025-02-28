package flow_field
import  "core:fmt"
import rl "vendor:raylib"

MAX_COST : int : 255

ff_pathfinder_calculate :: proc (grid : ^FFGrid, start : FFTile) -> (map[FFTile]int,bool) #optional_ok {
    frontier : Queue
    distance : map[FFTile]int

    if start.type == TileType.Wall {
        return nil,false
    }

    append(&frontier, start)
    distance[start] = 0
    for !queue_is_empty(&frontier) {
        current := queue_dequeue(&frontier)
        neighbours := ff_grid_get_neighbours(grid, current)
        for next in neighbours {
            if (next == nil || next.type == TileType.Wall) {
                continue
            }
            if next^ not_in distance {
                queue_enqueue(&frontier, next^)
                distance[next^] = distance[current] + 1
            }
        }
    }
    return distance,true
}

ff_pathfinder_cost_field_to_flow_field :: proc (grid : ^FFGrid, cost_field : map[FFTile]int, target_index : int) -> [GRID_WIDTH * GRID_HEIGHT]rl.Vector2 {

    flow_field := [GRID_WIDTH*GRID_HEIGHT]rl.Vector2{}
    target := grid.tiles[target_index]
    for i in 0..<len(grid.tiles) {
        cheapest_neighbour_cost := MAX_COST
        cheapest_neighbour : FFTile
        
        neighbours := ff_grid_get_neighbours(grid, grid.tiles[i])
        
        if grid.tiles[i] == target {
            flow_field[i] = rl.Vector2{0, 0}
            continue
        }
        
        for neighbour in neighbours {
            if neighbour == nil {
                continue
            }

            if neighbour^ in cost_field {
                if cost_field[neighbour^] < cheapest_neighbour_cost {
                    cheapest_neighbour_cost = cost_field[neighbour^]
                    cheapest_neighbour = neighbour^
                }
            }
        }

        flow_field[i] = rl.Vector2{f32(cheapest_neighbour.x - grid.tiles[i].x), f32(cheapest_neighbour.y - grid.tiles[i].y)}
    }
    return flow_field
}