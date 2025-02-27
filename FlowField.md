Un flow field es un grid donde cada cell tiene un costo y una direccion en relacion a un punto target

El algoritmo tiene 2 partes, "cost calculation" y "flow direction calculation"

# Cost calculation

Consiste en hacer un `Breadth First Search`(BFS).
BFS es un search algorithm donde exploro las cells alrededor de un cell inicial(el target)
y calculo el costo desde el target hasta esa cell.