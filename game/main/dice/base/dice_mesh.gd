@tool
extends MeshInstance3D
class_name DiceMesh

var mat := preload("res://game/resources/material/regular_dice_material.tres").duplicate()
var colors := preload("res://game/resources/global/color/board_colors.tres")
var state := preload("res://game/resources/global/state/board_state.tres")

var color: Color
var targetBasis: Basis

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
	mat.albedo_color = colors.cubeColor

func _process(delta: float) -> void:
	updateRotation()
	
func updateRotation() -> void:
	pass
	
func enableOutline() -> void:
	mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	mat.stencil_color = colors.selectionColor
	
func disabelOutline() -> void:
	mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED

func setColor(color : Color) -> void:
	mat.albedo_color = color
