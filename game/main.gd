extends Node3D

@export var dimension := 8:
	set(value):
		dimension = value
@export var spacing := 1.2:
	set(value):
		spacing = value
@export var cubeSize := 1.0:
	set(value):
		cubeSize = value

@onready var boardRoot = $Board
@onready var bLogic : BoardLogic = $Board/Logic
@onready var bVisuals : BoardVisuals = $Board/Visuals

@onready var ui = $CanvasLayer/UI

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	checkInput()
	pass
	
func checkInput():	
	if Input.is_action_just_pressed("fire"):
		bLogic.activateCube()
		
	elif Input.is_action_just_pressed("cycle_left"):
		ui.edge = bLogic.updateEdge(true)
		
	elif Input.is_action_just_pressed("cycle_right"):
		ui.edge = bLogic.updateEdge(false)
