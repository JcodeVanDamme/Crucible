@tool
extends Node3D
class_name CubeRenderer

var cubeScene = preload("res://game/dice/regular_dice.tscn")

var state : BoardState

func init() -> void:
	var dices = {}
	for child in get_children(): 
		remove_child(child)
	state.dices = dices
		
func spawnCube() -> void:
	add_child(state.currentDice)
	state.currentDice.visible = false
		
func previewCurrentDie() -> void:
	var pos = state.laneStart
	state.currentDice.position = Board.toLocalPos(
		pos,
		0
	)
	state.currentDice.visible = true
	"""var mesh = state.currentDice.get_child(0)
	var mat = mesh.get_active_material(0) as ShaderMaterial
	mat.set_shader_parameter("in_lane", true)"""
	
func hideDiePreview() -> void:
	state.currentDice.visible = false
	"""var mesh = state.currentDice.get_child(0)
	var mat = mesh.get_active_material(0) as ShaderMaterial
	mat.set_shader_parameter("in_lane", true)"""
	
func updateDicePosition(id : int) -> void:
	var dice = state.dices.get(id)
	var pos = dice.pos

	dice.position = Board.toLocalPos(
		pos,
		0
	)
	
func deleteDice(id : int) -> void:
	var dice = state.dices.get(id)
	remove_child(dice)
	state.dices.erase(dice)
