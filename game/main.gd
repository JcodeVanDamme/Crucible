@tool
extends Node3D

func _ready() -> void:
	if Engine.is_editor_hint():
		$BoardRoot.globals_changed.connect(
			func():
			$BoardRoot/Board.buildBoard()
			$BoardRoot/Visuals.init()
			)
		$BoardRoot/Board.state = $BoardRoot/State
		$BoardRoot/Board.buildBoard()
		$BoardRoot/Visuals.init()
	
	#$CanvasLayer/UI.edge = $BoardRoot/Board.updateEdge(true)
	Board.camera = $BoardRoot/CameraController/Camera3D
