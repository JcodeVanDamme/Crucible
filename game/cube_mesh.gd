@tool
extends MeshInstance3D

var mat = preload("res://game/cube_material.tres")

func _enter_tree() -> void:
	material_override = mat.duplicate()

func shader(property : String, val : bool) -> void:
	material_override.set_shader_parameter(property, val)
