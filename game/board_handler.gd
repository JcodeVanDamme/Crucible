extends Node
class_name BoardHandler

var state = preload("res://game/board_state.tres")
var board = preload("res://game/board.tres")

func moveDie(id : int) -> void:
	var die = state.dices.get(id)
	die.position = board.toLocalPos(die.pos, 0)
	
func deleteDie(id : int) -> void:
	var die = state.dices.get(id)
	var parent = die.get_parent() as Node
	parent.remove_child(die)
	state.dices.erase(id)

func finished() -> void:
	pass
