extends Node
class_name BoardLogic

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")

func _ready() -> void:
	events.selection_locked.connect(func():
		assembleActionQueue()
		assemblePreviewMatrix()
		events.preview_ready.emit()
	)
	events.selection_unlocked.connect(func():
		state.previewMatrix = null
		for action:Action in state.actionQueue:
			action.executor.diceData.faces.resetPreview()
	)
	buildBoard()

func buildBoard():
	var layout := {}
	for x in range(board.dimension):
		for y in range(board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	state.positionalMatrix = layout
	
func assembleActionQueue():
	var dices : Array = getDicesInLane()
	var actionQueue : Array = processDiceQueue(dices)
	state.actionQueue = actionQueue
		
func getDicesInLane() -> Array:
	var queue := []
	
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
				
			action.executor = dice
			action.type = Actions.ActionType.MOVE_OFF_BOARD
			action.moveFrom = originalPos
			action.moveTo = newPos
			dice.diceData.faces.updateFaces(state.rollAxis)
					
		else:
			
			action = Actions.supply(
				Actions.ActionType.MOVE
				) as MoveAction
			
			action.executor = dice
			action.type = Actions.ActionType.MOVE
			action.moveFrom = originalPos
			action.moveTo = newPos
			dice.diceData.faces.updateFaces(state.rollAxis)
			

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
	
func assemblePreviewMatrix() -> void:
	var matrix = state.positionalMatrix.duplicate()
	
	for i in range(state.actionQueue.size()):
		var action := state.actionQueue.get(i) as Action
		
		match action.type:
			
			Actions.ActionType.MOVE, Actions.ActionType.MOVE_OFF_BOARD:
			
				var moveAction := action as MoveAction
				matrix.set(moveAction.moveFrom, null)
				matrix.set(moveAction.moveTo, moveAction.executor.id)
	
	state.previewMatrix = matrix
