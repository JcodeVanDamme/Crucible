@tool
extends Node3D

var board := preload("res://game/board.tres")

func _ready() -> void:
	if Engine.is_editor_hint():
		board.board_changed.connect(
			func():
			$BoardRoot/Board.buildBoard()
			$BoardRoot/Visuals/Tiles.buildTiles()
			)
		$BoardRoot/Board.buildBoard()
		$BoardRoot/Visuals/Tiles.buildTiles()
	
	board.camera = $BoardRoot/CameraController/Camera3D
