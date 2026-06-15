extends Node

var state = preload("res://game/resources/global/state/board_state.tres")
var board = preload("res://game/resources/global/board/board.tres") 
var events = preload("res://game/resources/global/event/events.tres")

const MOVE_DURATION: float = 0.4
const POS_INCREASE: float = 0.06

func animateMoveAction(action:MoveAction, queuePos: float) -> void:
	var dice:Dice = state.dices.get(action.executorId)
	
	if dice.tween:
		dice.tween.kill()
	dice.tween = get_tree().create_tween()
	dice.tween.set_parallel(true)
	dice.tween.set_trans(Tween.TRANS_SPRING)
	dice.tween.set_ease(Tween.EASE_IN_OUT)
	
	dice.tween.tween_property(
		dice,
		"position",
		board.toLocalPos(action.moveTo, 0),
		MOVE_DURATION + POS_INCREASE * queuePos
	)
	
	dice.initRoll(1)
	dice.tween.tween_property(
		dice,
		"rotationProgress",
		1.0, MOVE_DURATION
	)
		
func animateMoveOffBoardAction(action:MoveOffBoardAction, queuePos: float) -> void:
	var dice:Dice = state.dices.get(action.executorId)
	
	if dice.tween:
		dice.tween.kill()
	dice.tween = get_tree().create_tween()
	dice.tween.set_parallel(true)
	dice.tween.set_trans(Tween.TRANS_SPRING)
	dice.tween.set_ease(Tween.EASE_IN_OUT)
	
	dice.tween.tween_property(
		dice,
		"position",
		board.toLocalPos(action.moveTo, 1.0),
		MOVE_DURATION + POS_INCREASE * queuePos
	)
	
	dice.initRoll(1)
	dice.tween.tween_property(
		dice,
		"rotationProgress",
		1.0, MOVE_DURATION
	)
	
func animateRevert(action: Action) -> void:
	var dice = state.dices.get(action.executorId)
	
	if dice.tween:
		dice.tween.kill()
	dice.tween = get_tree().create_tween()
	dice.tween.set_parallel(true)
	dice.tween.set_trans(Tween.TRANS_SPRING)
	dice.tween.set_ease(Tween.EASE_IN_OUT)
	
	dice.tween.tween_property(
		dice,
		"position",
		board.toLocalPos(action.pos, 0),
		MOVE_DURATION
	)
		
	dice.initRoll(-1)
	dice.tween.tween_property(
		dice,
		"rotationProgress",
		1.0, MOVE_DURATION
	)
	
	dice.mesh.setColor(dice.mesh.color)
