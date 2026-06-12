extends Node
class_name InputHandler

var state = preload("res://game/board_state.tres")
var events = preload("res://game/events.tres")

var cameraHandler : CameraHandler
		
func _process(delta: float) -> void:
	checkInput()
		
func checkInput():
	if Input.is_action_just_pressed("confirm"):
		
		""" No Lane Locked but Edge Tile in selection """
		""" -> Lock Lane at selected Edge Tile """
		if !state.selectionLocked && state.isLaneSelected:
			
			state.selectionLocked = true
			events.selection_locked.emit()
		
			""" Lane Locked but Edge Tile in selection """
			""" -> Lock Lane at selected Edge Tile """
		elif state.selectionLocked:
			
			events.selection_executed.emit()
			
	elif Input.is_action_just_pressed("abort") && state.selectionLocked:
		state.selectionLocked = false
		events.selection_unlocked.emit()
		
	elif Input.is_action_just_pressed("cycle_left"):
		cameraHandler.updateAnchor(1)
		
	elif Input.is_action_just_pressed("cycle_right"):
		cameraHandler.updateAnchor(-1)
