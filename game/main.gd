extends Node3D

@onready var board: Node3D = $Board

var selected_material := StandardMaterial3D.new()
var default_material := StandardMaterial3D.new()

@onready var ui = $CanvasLayer/UI

func _ready() -> void:
	ui.edge = board.EDGE_NAMES[board.currentEdge]
	
func _process(delta: float) -> void:
	checkInput()
	pass
	
func checkInput():	
	if Input.is_action_just_pressed("fire"):
		board.activateCube()
		
	elif Input.is_action_just_pressed("cycle_left"):
		ui.edge = board.updateEdge(true)
		
	elif Input.is_action_just_pressed("cycle_right"):
		ui.edge = board.updateEdge(false)
