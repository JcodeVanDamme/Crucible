extends Node
class_name DiceSupplier

var diceScene = preload("res://game/dice/regular_dice.tscn")

var state : BoardState
var diceId := 0

signal determinedDie()

func determineDie() -> void:
	var dice = diceScene.instantiate()
	dice.init(diceId)
	diceId += 1
	
	state.dices.set(dice.id, dice)
	state.currentDice = dice
	determinedDie.emit()
