extends Node

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")
var colors := preload("res://game/resources/global/color/board_colors.tres")

@onready var animations: Node = $Animations

func _ready() -> void:
	events.preview_ready.connect(previewActions)
	events.selection_unlocked.connect(revertPreview)
	events.selection_executed.connect(resetColors)

func previewActions() -> void:
	var queuePos: int = 0
	for i in range(state.actionQueue.size()):
		var action: Action = state.actionQueue.get(i) as Action

		if action.type == Actions.ActionType.MOVE:
			previewMove(action, queuePos)
			
		elif action.type == Actions.ActionType.MOVE_OFF_BOARD:
			previewMoveOffBoard(action, queuePos)
			
		queuePos += 1
	
func resetColors() -> void:
	for i in range(state.actionQueue.size()):
		var action: Action = state.actionQueue.get(i) as Action
		var dice:Dice = state.dices.get(action.executorId)
		dice.mesh.setColor(dice.mesh.color)

func revertPreview() -> void:
	for i in range(state.actionQueue.size()):
		var action:Action = state.actionQueue.get(i) as Action
		"""var action:Action = state.actionQueue.get(i) as Action
		var dice:Dice = state.dices.get(action.executorId)
		dice.position = board.toLocalPos(action.originalPos, 0)
		dice.mesh.setColor(dice.mesh.color)"""
		animations.animateRevert(action)
			
func previewMove(action : MoveAction, queuePos: int) -> void:
	var dice:Dice = state.dices.get(action.executorId)
	#dice.position = board.toLocalPos(action.moveTo, 0)
	animations.animateMoveAction(action, queuePos)
	dice.mesh.setColor(colors.actionMoved)
	
func previewMoveOffBoard(action : MoveOffBoardAction, queuePos: int) -> void:
	var dice:Dice = state.dices.get(action.executorId)
	#dice.position = board.toLocalPos(action.moveTo, 0)
	animations.animateMoveOffBoardAction(action, queuePos)
	dice.mesh.setColor(colors.actionMovedOffBoard)
