@tool
extends Node
class_name BoardLogic

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")

func _ready() -> void:
	events.selection_locked.connect(assembleActionQueue)
	buildBoard()

func buildBoard():
	var layout = {}
	for x in range(board.dimension):
		for y in range(board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	state.positionalMatrix = layout
	
func assembleActionQueue():
	var dices = getDicesInLane()
	var actionQueue = processDiceQueue(dices)
	state.actionQueue = actionQueue
	events.action_queue_ready.emit()
		
func getDicesInLane() -> Array:
	var queue = []
	
	""" Append the newly spawned Cube """
	queue.push_front(state.spawnedDie.id)
	
	""" Start Loop at Spawned Cube + PushDir """
	var coord = state.spawnedDie.pos + state.pushDirection
	
	""" Keep processing while in Bounds """
	while checkBounds(coord):
		var id = state.positionalMatrix.get(coord)
		if id != null:
			queue.push_front(id)
			coord += state.pushDirection
			
			""" Abort when no more Cubes present in Lane """
		else:
			break
			
	return queue
	
func processDiceQueue(dices : Array) -> Array:
	var actionQueue = []

	for i in range(dices.size()):
		
		var id = dices.get(i)
		var dice = state.dices.get(id)
		
		""" Face Logic not implemented yet, Dice move one field toward pushDir """
		var originalPos = dice.pos
		var newPos = originalPos + state.pushDirection
		
		""" Only differentiate if it moves off the board """
		var action : Action
		
		""" ! Quick Workaround; Spawned die is on Edge -> dont move off board  ! """
		if !checkBounds(newPos) && id != state.spawnedDie.id:
			
			action = Actions.supply(
				Actions.ActionType.MOVE_OFF_BOARD
				) as MoveOffBoardAction
				
			action.executorId = id
			action.type = Actions.ActionType.MOVE_OFF_BOARD
			action.moveFrom = originalPos
			action.moveTo = newPos
		
		else:
			
			action = Actions.supply(
				Actions.ActionType.MOVE
				) as MoveAction
				
			action.executorId = id
			action.type = Actions.ActionType.MOVE
			action.moveFrom = originalPos
			action.moveTo = newPos
			
		#actionQueue.push_front(action)
		actionQueue.append(action)
		
	return actionQueue
		
func checkBounds(pos) -> bool:
	if pos.x < 1:
		return false
	if pos.x > board.dimension - 2:
		return false
	if pos.y < 1:
		return false
	if pos.y > board.dimension - 2:
		return false
	return true
