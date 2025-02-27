package game

GRID_WIDTH : int : 40 // size based on window
GRID_HEIGHT : int : 22 // size based on window
TILE_SIZE : int : 32

FFGrid :: struct {
    tiles : [GRID_WIDTH * GRID_HEIGHT]FFTile,
    width : int,
    height : int,
    tile_size : int,
}

ff_grid_make :: proc () -> ^FFGrid {
    result := new(FFGrid) // add grid to heap

    // dereference and fill
    result^ = {
        width = GRID_WIDTH,
        height = GRID_HEIGHT,
        tile_size = TILE_SIZE,
    }

    count := GRID_WIDTH * GRID_HEIGHT
    for i in 0..<count {
        result.tiles[i] = FFTile{
            x = i % GRID_WIDTH,
            y = i / GRID_WIDTH,
            visited = false,
            wall = false,
        }
    }
    return result;
}

ff_grid_free :: proc (grid : ^FFGrid) {
    free(grid)
}