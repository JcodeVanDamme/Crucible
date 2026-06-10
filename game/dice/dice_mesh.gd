@tool
extends MeshInstance3D
class_name DiceMesh

var mat = preload("res://game/Dice.tres").duplicate()

@export var showOutline := false:
	set(value):
		showOutline = value
		if showOutline:
			enableOutline()
		else:
			disabelOutline()

func _ready() -> void:
	showOutline = false
	set_surface_override_material(0, mat)
	mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
	mat.albedo_color = Colors.cubeColor
	
func enableOutline() -> void:
	mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	mat.stencil_color = Colors.selectionColor
	
func disabelOutline() -> void:
	mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
