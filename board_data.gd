extends Node

class_name BoardData

var size: int
var grid: Array[Array]
var edge: Array[Vector2] = []

func init_grid():
	grid.clear()
	for x in size:
		grid.append([])
		for y in size:
			grid[x].append(null)
			
func buildEdgeCoords():
	
	""" Left column """
	for y in range(size):
		edge.append(Vector2(0, y))

	""" Right column """
	for y in range(size):
		edge.append(Vector2(size, y))
