extends Node3D

@onready var boardLogic : Node3D = $BoardLogic
@onready var ui = $CanvasLayer/UI

func _ready() -> void:
	#ui.edge = Edge.toString(board.currentEdge)
	pass
	
func _process(delta: float) -> void:
	checkInput()
	pass
	
func checkInput():	
	if Input.is_action_just_pressed("fire"):
		boardLogic.activateCube()
		
	elif Input.is_action_just_pressed("cycle_left"):
		ui.edge = boardLogic.updateEdge(true)
		
	elif Input.is_action_just_pressed("cycle_right"):
		ui.edge = boardLogic.updateEdge(false)
