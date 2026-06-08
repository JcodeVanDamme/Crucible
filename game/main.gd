@tool
extends Node3D

@onready var boardRoot = $BoardRoot
@onready var bLogic : BoardLogic = $BoardRoot/Logic
@onready var bVisuals : BoardVisuals = $BoardRoot/Visuals
@onready var ui = $CanvasLayer/UI
@onready var cameraController = $CameraController

func _ready() -> void:
	if Engine.is_editor_hint():
		$BoardRoot.globals_changed.connect(
			func():
			$BoardRoot/Logic.build_board()
			)
	$BoardRoot/Logic.build_board()
	Board.camera = $CameraController/Camera3D
	
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		checkInput()
	
func checkInput():	
	if Input.is_action_just_pressed("fire"):
		bLogic.activateCube()
		
	if Input.is_action_just_pressed("cycle_left") && !Input.is_action_pressed("alternate"):
		ui.edge = bLogic.updateEdge(true)
		
	elif Input.is_action_just_pressed("cycle_left") && !cameraController.moving:
		cameraController.updateAnchor(1)
		
	if Input.is_action_just_pressed("cycle_right") && !Input.is_action_pressed("alternate"):
		ui.edge = bLogic.updateEdge(false)
		
	elif Input.is_action_just_pressed("cycle_right") && !cameraController.moving:
		cameraController.updateAnchor(-1)
