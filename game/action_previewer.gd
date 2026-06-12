extends Node

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")
var colors := preload("res://game/resources/global/color/board_colors.tres")

func _ready() -> void:
	events.action_queue_ready.connect(previewActions)
	events.selection_unlocked.connect(revertPreview)
	events.selection_executed.connect(resetColors)

func previewActions() -> void:
	for i in range(state.actionQueue.size()):
		var action = state.actionQueue.get(i) as Action

		if action.type == Actions.ActionType.MOVE:
			previewMove(action)
			
		elif action.type == Actions.ActionType.MOVE_OFF_BOARD:
			previewMoveOffBoard(action)
	
func resetColors() -> void:
	for i in range(state.actionQueue.size()):
		var action = state.actionQueue.get(i) as Action
		var dice = state.dices.get(action.executorId)
		dice.mesh.setColor(dice.mesh.color)

func revertPreview() -> void:
	for i in range(state.actionQueue.size()):
		var action = state.actionQueue.get(i) as Action
		var dice = state.dices.get(action.executorId)
		dice.position = board.toLocalPos(action.originalPos, 0)
		dice.mesh.setColor(dice.mesh.color)
			
func previewMove(action : MoveAction) -> void:
	var dice = state.dices.get(action.executorId)
	dice.position = board.toLocalPos(action.moveTo, 0)
	dice.mesh.setColor(colors.actionMoved)
	
func previewMoveOffBoard(action : MoveOffBoardAction) -> void:
	var dice = state.dices.get(action.executorId)
	dice.position = board.toLocalPos(action.moveTo, 0)
	dice.mesh.setColor(colors.actionMovedOffBoard)
