extends Node

var state = preload("res://game/resources/global/state/board_state.tres")
var board = preload("res://game/resources/global/board/board.tres") 
var events = preload("res://game/resources/global/event/events.tres")

enum AnimationType {
	PREVIEW,
	REVERSE,
	EXECUTION
}

func _ready() -> void:
	events.selection_locked.connect(func():
		animate(AnimationType.PREVIEW)
		)
	events.selection_unlocked.connect(func():
		animate(AnimationType.REVERSE)
		)
	events.selection_executed.connect(func():
		animate(AnimationType.EXECUTION)
		)
	
func animate(type : AnimationType) -> void:
	var queuePos:int = 0
	for action:Action in state.actionQueue:
		match type:
			AnimationType.PREVIEW:
				action.previewAnimation.call(queuePos)
			AnimationType.EXECUTION:
				action.executionAnimation.call(queuePos)
			AnimationType.REVERSE:
				action.reverseAnimation.call(queuePos)
	
		queuePos += 1
