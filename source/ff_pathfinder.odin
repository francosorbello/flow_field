package game

FFPathfinder :: struct {
    grid : FFGrid,
}

ff_pathfinder_init :: proc(grid : FFGrid) -> FFPathfinder {
    result := FFPathfinder{
        grid = FFGrid{
            
        } 
    }
    return result
}