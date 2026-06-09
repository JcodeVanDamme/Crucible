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
	print("Spawning Cube")
	add_child(state.currentDice)
	state.currentDice.visible = false
		
func previewCurrentDie() -> void:
	var matrixPos = state.laneStart - state.pushDirection
	
	var step = Board.cubeSize + Board.spacing
	var center_index = (Board.dimension - 1) * 0.5
	
	state.currentDice.position = Vector3(
		(matrixPos.x - center_index) * step,
		0,
		(matrixPos.y - center_index) * step
	)
	state.currentDice.visible = true
	
func hideDiePreview() -> void:
	state.currentDice.visible = false
	
func updateDicePosition(id : int) -> void:
	var dice = state.dices.get(id)
	var pos = dice.pos
	
	var step = Board.cubeSize + Board.spacing
	var center_index = (Board.dimension - 1) * 0.5
	dice.position = Vector3(
		(pos.x - center_index) * step,
		0,
		(pos.y - center_index) * step
	)
	
func deleteDice(id : int) -> void:
	var dice = state.dices.get(id)
	remove_child(dice)
	state.dices.erase(dice)
