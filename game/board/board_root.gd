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
		
var width : float
		
func updateGlobals() -> void:
	Board.dimension = dimension
	Board.spacing = spacing
	Board.cubeSize = cubeSize
	Board.width = dimension * (cubeSize + spacing)
	globals_changed.emit()
