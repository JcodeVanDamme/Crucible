extends Node
class_name DiceSupplier

var diceScene = preload("res://game/dice/regular_dice.tscn")

var state = preload("res://game/board_state.tres")

var diceId := 1

func determineDie() -> void:
	var dice = diceScene.instantiate()
	dice.init(diceId)
	diceId += 1
	
	state.dices.set(dice.id, dice)
	state.spawnedDie = dice
