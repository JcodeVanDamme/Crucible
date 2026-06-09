@tool
extends Node3D
class_name BoardVisuals

@onready var cubeRenderer = $Cubes as CubeRenderer
@onready var tileRenderer = $Tiles as TileRenderer

var state : BoardState

func init() -> void:
	$Cubes.state = state
	$Tiles.state = state
	$Cubes.init()
	$Tiles.buildTiles()
