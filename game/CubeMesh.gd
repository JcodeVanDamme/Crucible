@tool
extends MeshInstance3D

var outline_shader = preload("res://game/OutlineShader.gdshader")
var inactive_material = preload("res://game/inactive_material.tres")
var active_material = preload("res://game/active_material.tres")
var outline_mat : ShaderMaterial

@export var outline_color := Color.YELLOW:
	set(value):
		outline_color = value
		outline_mat = make_outline_material()
		
@export var outline_size := 0.05:
	set(value):
		outline_size = value
		outline_mat = make_outline_material()

func _enter_tree() -> void:
	outline_mat = make_outline_material().duplicate()
	material_override = inactive_material.duplicate()

func make_outline_material() -> ShaderMaterial:
	var mat := ShaderMaterial.new()
	mat.shader = outline_shader
	mat.set_shader_parameter("outline_color", outline_color)
	mat.set_shader_parameter("outline_size", outline_size)
	return mat
