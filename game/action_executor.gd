extends Node

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")

func _ready() -> void:
	events.selection_executed.connect(func():
		executeQueriedActions()
		events.turn_ended.emit()
		)

func executeQueriedActions() -> void:
	var actions = state.actionQueue
	
	""" Push Dice in Chain from back to front """
	for i in range(actions.size()):
		var action = actions.get(i) as Action
		
		match action.type:
			
			Actions.ActionType.MOVE:
				executeMove(action)
				
			Actions.ActionType.MOVE_OFF_BOARD:
				executeMoveOffBoard(action)
				
	
func executeMove(action : MoveAction) -> void:
	var dice = state.dices.get(action.executorId)
	dice.pos = action.moveTo
	
	state.positionalMatrix.set(action.moveTo, action.executorId)
	state.positionalMatrix.set(action.originalPos, null)
	dice.position = board.toLocalPos(dice.pos, 0)

func executeMoveOffBoard(action : MoveOffBoardAction) -> void:
	var dice = state.dices.get(action.executorId)
	var parent = dice.get_parent() as Node
	parent.remove_child(dice)
