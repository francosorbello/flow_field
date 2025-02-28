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

    for i in 0..<GRID_WIDTH * 4{
        result.tiles[i].type = TileType.Wall
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

    up := ff_grid_pos_to_tile(grid, x, y - 1)
    down := ff_grid_pos_to_tile(grid, x, y + 1)
    left := ff_grid_pos_to_tile(grid, x - 1, y)
    right := ff_grid_pos_to_tile(grid, x + 1, y)
    
    if up != nil && up.type != TileType.Wall {
        result[0] = up
    }
    if down != nil && down.type != TileType.Wall {
        result[1] = down
    }
    if left != nil && left.type != TileType.Wall {
        result[2] = left
    }
    if right != nil && right.type != TileType.Wall {
        result[3] = right
    }
    return result
}