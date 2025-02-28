package flow_field

TileType :: enum {
    Walkable,
    Expensive,
    Wall,
}

FFTile :: struct {
    x : int,
    y : int,
    type : TileType,
}

