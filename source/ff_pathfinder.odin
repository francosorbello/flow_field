package game
import  "core:fmt"
FFPathfinder :: struct {
    grid : FFGrid,
    frontier : Queue,
    distance : map[FFTile]int,
}

ff_pathfinder_calculate :: proc (grid : ^FFGrid, start : FFTile) -> map[FFTile]int {
    result := FFPathfinder {
        grid = grid^
    }
    append(&result.frontier, start)
    result.distance[start] = 0
    for !queue_is_empty(&result.frontier) {
        current := queue_dequeue(&result.frontier)
        neighbours := ff_grid_get_neighbours(grid, current)
        for next in neighbours {
            if (next == nil) {
                continue
            }
            if next^ not_in result.distance {
                queue_enqueue(&result.frontier, next^)
                result.distance[next^] = result.distance[current] + 1
            }
        }
    }
    return result.distance
}