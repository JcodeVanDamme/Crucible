@tool
extends Node3D

signal globals_changed

@export var dimension := 8:
	set(value):
		dimension = value
		updateGlobals()
		
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
		globals_changed.emit()
		
@export var tileMainColor := Color.GRAY:
	set(value):
		tileMainColor = value
		Colors.tileMainColor = tileMainColor
		globals_changed.emit()
		
@export var tileEdgeColor := Color.GRAY:
	set(value):
		tileEdgeColor = value
		Colors.tileEdgeColor = tileEdgeColor
		globals_changed.emit()
		
@export var highlightColor := Color.HOT_PINK:
	set(value):
		highlightColor = value
		Colors.highlightColor = highlightColor
		globals_changed.emit()
		
var width : float
		
func updateGlobals() -> void:
	Board.dimension = dimension
	Board.spacing = spacing
	Board.cubeSize = cubeSize
	Board.width = (dimension) * (cubeSize + spacing)
	globals_changed.emit()
