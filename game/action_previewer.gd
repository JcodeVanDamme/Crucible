extends Node

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")

func _ready() -> void:
	events.action_queue_ready.connect(previewActions)

func previewActions() -> void:
	for i in range(state.actionQueue.size()):
		print ("Action ", i)
		
		var action = state.actionQueue.get(i) as Action
		print("Cube: ", action.executorId)

		if action.type == Actions.ActionType.MOVE:
			var moveAction := action as MoveAction
			
			print("Action Type: MOVE")
			print("From: ", moveAction.moveFrom)
			print("To: ", moveAction.moveTo)
			
		elif action.type == Actions.ActionType.MOVE_OFF_BOARD:
			var moveOffAction := action as MoveAction
			
			print("Action Type: MOVE_OFF_BOARD")
			print("From: ", moveOffAction.moveFrom)
			print("To: ", moveOffAction.moveTo)
			
		else:
			print("Invalid Action")
			
	print("")
