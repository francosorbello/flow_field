package game
import  "core:fmt"

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