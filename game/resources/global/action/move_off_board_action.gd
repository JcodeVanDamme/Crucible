extends MoveAction
class_name MoveOffBoardAction

func _init() -> void:
	super()
	
	var parentPreview: Callable = previewAnimation
	
	previewAnimation = func(queuePos: int):
	
		parentPreview.call(queuePos)
		executor.mesh.setColor(colors.actionMovedOffBoard)
