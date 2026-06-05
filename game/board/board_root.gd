@tool
extends Node3D

@export var dimension := 8:
	set(value):
		dimension = value
		updateBoardWidth()
		
@export var spacing := 1.2:
	set(value):
		spacing = value
		updateBoardWidth()
		
@export var cubeSize := 1.0:
	set(value):
		cubeSize = value
		updateBoardWidth()
		
var width : float
		
func updateBoardWidth() -> void:
	width = dimension * (cubeSize + spacing)
