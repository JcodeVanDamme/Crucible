extends Node
class_name BoardHandler

var state : BoardState

func moveDie(id : int) -> void:
	var die = state.dices.get(id)
	die.position = Board.toLocalPos(die.pos, 0)
	
func deleteDie(id : int) -> void:
	var die = state.dices.get(id)
	var parent = die.get_parent() as Node
	parent.remove_child(die)
	state.dices.erase(id)

func finished() -> void:
	pass
