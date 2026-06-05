@tool
extends Node3D

@onready var boardRoot = $BoardRoot
@onready var bLogic : BoardLogic = $BoardRoot/Logic
@onready var bVisuals : BoardVisuals = $BoardRoot/Visuals
@onready var ui = $CanvasLayer/UI

func _ready() -> void:
	if Engine.is_editor_hint():
		$BoardRoot.globals_changed.connect(
			func():
			$BoardRoot/Logic.build_board()
			)
	$BoardRoot/Logic.build_board()
	
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		checkInput()
	
func checkInput():	
	if Input.is_action_just_pressed("fire"):
		bLogic.activateCube()
		
	elif Input.is_action_just_pressed("cycle_left"):
		ui.edge = bLogic.updateEdge(true)
		
	elif Input.is_action_just_pressed("cycle_right"):
		ui.edge = bLogic.updateEdge(false)
