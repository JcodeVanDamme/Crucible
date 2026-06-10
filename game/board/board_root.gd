@tool
extends Node3D

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
		globals_changed.emit()
		
@export var cubeSize := 1.0:
	set(value):
		cubeSize = value
		updateGlobals()
		globals_changed.emit()
		
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
	Board.dimension = dimension
	Board.spacing = spacing
	Board.cubeSize = cubeSize
	Board.width = (dimension) * (cubeSize + spacing)
	globals_changed.emit()
