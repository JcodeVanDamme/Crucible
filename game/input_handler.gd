extends Node
class_name InputHandler

var state = preload("res://game/board_state.tres")
var events = preload("res://game/events.tres")
		
func _process(delta: float) -> void:
	checkInput()
		
func checkInput():	
	if Input.is_action_just_pressed("confirm"):
		if !state.selectionLocked && state.isLaneSelected:
			state.selectionLocked = true
			
		elif state.selectionLocked && state.isLaneSelected:
			events.selection_executed.emit()
			
	elif Input.is_action_just_pressed("abort") && state.selectionLocked:
		state.selectionLocked = false
		
	elif Input.is_action_just_pressed("cycle_left"):
		events.camera_update_queried.emit(1)
		
	elif Input.is_action_just_pressed("cycle_right"):
		events.camera_update_queried.emit(-1)
