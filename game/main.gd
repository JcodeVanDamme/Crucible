@tool
extends Node3D

func _ready() -> void:
	if Engine.is_editor_hint():
		$BoardRoot.globals_changed.connect(
			func():
			$BoardRoot/Board.buildBoard()
			$BoardRoot/Visuals/Tiles.buildTiles()
			)
		$BoardRoot/Board.state = $BoardRoot/State
		$BoardRoot/Board.buildBoard()
		$BoardRoot/Visuals/Tiles.buildTiles()
	
	Board.camera = $BoardRoot/CameraController/Camera3D
	
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		$CanvasLayer/UI.edge = $BoardRoot/State.edgeName()
