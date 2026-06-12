@tool
extends Node3D

@export var heigth := 0.2

func _ready() -> void:
	pass

func setSize(size : int) -> void:
	$MeshInstance3D.mesh.size = Vector3(
		size,
		heigth,
		size
	)
