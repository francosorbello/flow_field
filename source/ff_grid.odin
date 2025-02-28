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
            type = TileType.Walkable,
        }
    }
    return result;
}

ff_grid_free :: proc (grid : ^FFGrid) {
    free(grid)
}

ff_grid_pos_to_tile :: proc(grid : ^FFGrid, x, y : int) -> ^FFTile {
    if x < 0 || x >= grid.width || y < 0 || y >= grid.height {
        return nil
    }
    return &grid.tiles[y * grid.width + x]
}

ff_grid_pos_to_index :: proc(grid : ^FFGrid, x, y : int) -> int {
    return y * grid.width + x
}

ff_grid_world_pos_to_index :: proc(grid : ^FFGrid, x, y : int) -> int {
    return int(y / grid.tile_size) * grid.width + int(x / grid.tile_size)
}

ff_grid_get_neighbours :: proc(grid : ^FFGrid, tile : FFTile) -> [4]^FFTile {
    result := [4]^FFTile{}
    x := tile.x
    y := tile.y
    result[0] = ff_grid_pos_to_tile(grid, x, y - 1)
    result[1] = ff_grid_pos_to_tile(grid, x, y + 1)
    result[2] = ff_grid_pos_to_tile(grid, x - 1, y)
    result[3] = ff_grid_pos_to_tile(grid, x + 1, y)
    return result
}