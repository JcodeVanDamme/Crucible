extends Node
class_name DiceSupplier

var diceScene: PackedScene = preload("res://game/main/dice/instances/regular/regular_dice.tscn")

var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres") 
var colors = preload("res://game/resources/global/color/board_colors.tres")

var diceId:int = 1

func determineDie() -> Dice:
	var dice: Dice = diceScene.instantiate()
	dice.init(diceId, colors.cubeColor)
	diceId += 1
	return dice
