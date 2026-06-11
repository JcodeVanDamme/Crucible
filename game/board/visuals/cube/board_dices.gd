@tool
extends Node3D
class_name BoardDices

var state = preload("res://game/board_state.tres")

func init() -> void:
	for child in get_children(): 
		remove_child(child)
	state.dices = {}
		
func spawnCube() -> void:
	add_child(state.spawnedDie)
	state.spawnedDie.visible = false
