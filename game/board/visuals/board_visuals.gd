@tool
extends Node3D
class_name BoardVisuals

@onready var cubes = $Cubes as BoardCubes
@onready var tiles = $Tiles as BoardTiles
@onready var selectionCube = $SelectionCube as BoardSelectionCube

func init() -> void:
	cubes.init()
	tiles.buildTiles()
		
func spawnCube(data : CubeData) -> void:
	cubes.spawnCube(data)
	
func updateCubePosition(id : int) -> void:
	cubes.updateCubePosition(id)
	
func deleteCube(id : int) -> void:
	cubes.deleteCube(id)
	
func highlightLane(pos : Vector2, dir : Vector2) -> void:
	tiles.highlightLane(pos, dir)

func clearLaneHighlight() -> void:
	tiles.clearLaneHighlight()

func previewSelectionCube(pos : Vector2, dir : Vector2) -> void:
	selectionCube.previewSelectionCube(pos, dir)
	
func hideSelectionCube() -> void:
	selectionCube.hideSelectionCube()
