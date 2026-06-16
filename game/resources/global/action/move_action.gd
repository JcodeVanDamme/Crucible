extends Action
class_name MoveAction

const MOVE_DURATION:float = 0.4
const INCREASE:float = 0.05

var moveFrom: Vector2
var moveTo : Vector2

func _init() -> void:

	previewAnimation = func(queuePos: int):

		var dice:Dice = state.dices.get(executorId)
		if dice.tween:
			dice.tween.kill()
		dice.tween = dice.get_tree().create_tween()
		
		dice.tween.set_trans(Tween.TRANS_SPRING)
		dice.tween.set_ease(Tween.EASE_OUT)
		
		dice.tween.tween_property(
			dice,
			"position",
			board.toLocalPos(moveTo, 0),
			MOVE_DURATION + queuePos * INCREASE
		)
		
		dice.mesh.setColor(colors.actionMoved)
		
	reverseAnimation = func(queuePos: int):

		var dice:Dice = state.dices.get(executorId)
		if dice.tween:
			dice.tween.kill()
		dice.tween = dice.get_tree().create_tween()
		
		dice.tween.set_trans(Tween.TRANS_SPRING)
		dice.tween.set_ease(Tween.EASE_OUT)
		
		dice.tween.tween_property(
			dice,
			"position",
			board.toLocalPos(moveFrom, 0),
			MOVE_DURATION + (state.actionQueue.size() - 1 - queuePos) * INCREASE
		)
		
		dice.mesh.setColor(dice.mesh.color)
	
	executionAnimation = func(queuePos: int):
		var dice:Dice = state.dices.get(executorId)
		dice.mesh.setColor(dice.mesh.color)
