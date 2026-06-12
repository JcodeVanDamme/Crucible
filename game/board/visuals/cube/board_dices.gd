@tool
extends Node3D
class_name BoardDices

var state = preload("res://game/board_state.tres")
var events = preload("res://game/events.tres") 

func _ready() -> void:
	init()

func init() -> void:
	for child in get_children(): 
		remove_child(child)
	state.dices = {}
		
func spawnCube(dice : Dice) -> void:
	add_child(dice)
	dice.visible = false
	
	state.dices.set(dice.id, dice)
	state.spawnedDie = dice
	events.dice_spawned.emit()
