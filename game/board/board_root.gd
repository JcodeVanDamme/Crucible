@tool
extends Node3D

var board := preload("res://game/board.tres")

signal globals_changed

@export var dimension := 8:
	set(value):
		dimension = value
		updateGlobals()
		globals_changed.emit()
		
@export var spacing := 1.2:
	set(value):
		spacing = value
		updateGlobals()
		
@export var cubeSize := 1.0:
	set(value):
		cubeSize = value
		updateGlobals()
		
@export var cubeColor := Color.ORANGE:
	set(value):
		cubeColor = value
		Colors.cubeColor = cubeColor
		
@export var tileMainColor := Color.GRAY:
	set(value):
		tileMainColor = value
		Colors.tileMainColor = tileMainColor
		
@export var tileEdgeColor := Color.GRAY:
	set(value):
		tileEdgeColor = value
		Colors.tileEdgeColor = tileEdgeColor
		
@export var selectionColor := Color.HOT_PINK:
	set(value):
		selectionColor = value
		Colors.selectionColor = selectionColor
		
var width : float
		
func updateGlobals() -> void:
	board.dimension = dimension
	board.spacing = spacing
	board.cubeSize = cubeSize
	board.width = (dimension) * (cubeSize + spacing)
	board.board_changed.emit()
