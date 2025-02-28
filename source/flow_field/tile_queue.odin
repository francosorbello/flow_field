package flow_field 

Queue :: [dynamic]FFTile

queue_enqueue :: proc(queue: ^Queue , tile : FFTile) {
    append(queue, tile)
}

queue_dequeue :: proc(queue: ^Queue) -> FFTile {
    if  len(queue) == 0 {
        return FFTile{}
    }
    result := queue[0]
    ordered_remove(queue, 0)
    return result
}

queue_is_empty :: proc(queue: ^Queue) -> bool {
    return len(queue) == 0
}