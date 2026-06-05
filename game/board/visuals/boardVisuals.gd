@tool
extends Node3D
class_name BoardVisuals

@onready var cubes = $Cubes as BoardCubes
@onready var edges = $Edges as BoardEdges
@onready var tiles = $Tiles as BoardTiles

func init() -> void:
	cubes.init()
	tiles.buildTiles()
	edges.buildEdges()
		
func spawnCube(data : CubeData) -> void:
	cubes.spawnCube(data)
	
func updateCubePosition(id : int) -> void:
	cubes.updateCubePosition(id)
	
func deleteCube(id : int) -> void:
	cubes.deleteCube(id)
	
func highlightLane(pos : Vector2, dir : Vector2) -> void:
	tiles.highlightLane(pos, dir)
