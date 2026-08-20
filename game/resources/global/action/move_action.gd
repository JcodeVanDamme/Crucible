extends Action
class_name MoveAction

const MOVE_DURATION:float = 0.4
const INCREASE:float = 0.05

var moveFrom: Vector2
var moveTo : Vector2

func _init() -> void:

	previewAnimation = func(queuePos: int):		
		initTween()
		var duration:float = MOVE_DURATION + queuePos * INCREASE
		
		move(moveTo, duration)
		roll(duration, Basis(state.rollAxis, PI / 2.0))
		
		executor.mesh.setColor(colors.actionMoved)
		
	reverseAnimation = func(queuePos: int):
		initTween()
		var duration = MOVE_DURATION + (state.actionQueue.size() - 1 - queuePos) * INCREASE
		
		move(moveFrom, duration)
		roll(duration, Basis(state.rollAxis, -PI / 2.0))
		
		executor.mesh.setColor(executor.mesh.color)
	
	executionAnimation = func(queuePos: int):
		executor.mesh.setColor(executor.mesh.color)
	
func initTween() -> void:
	executor.startTween()
	executor.tween.set_trans(Tween.TRANS_SPRING)
	executor.tween.set_ease(Tween.EASE_OUT)	

func move(pos:Vector2, duration:float) -> void:
	executor.tween.parallel().tween_property(
		executor,
		"position",
		board.toLocalPos(pos, 0),
		duration
	)
	
func roll(duration:float, rotation:Basis) -> void:
	var startBasis:Basis = executor.mesh.targetBasis
	
	executor.mesh.targetBasis = rotation * startBasis
	
	executor.tween.parallel().tween_method(
		func(t):
			executor.mesh.basis = startBasis.slerp(
				executor.mesh.targetBasis,
				t
			),
			0.0,
			1.0,
			duration
		)
