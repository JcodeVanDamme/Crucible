extends Node
class_name InputHandler

var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")

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
		
			""" Lane Locked"""
			""" -> Execute Selection """
		elif state.selectionLocked:
			
			events.selection_executed.emit()
			
		""" Lane is locked """
		""" -> Unlock Lane """
	elif Input.is_action_just_pressed("abort") && state.selectionLocked:
		state.selectionLocked = false
		events.selection_unlocked.emit()
		
		""" Update Camera """
	elif Input.is_action_just_pressed("cycle_left"):
		cameraHandler.updateAnchor(1)
		
	elif Input.is_action_just_pressed("cycle_right"):
		cameraHandler.updateAnchor(-1)
