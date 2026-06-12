extends Node
class_name DiceSupplier

var diceScene = preload("res://game/dice/regular_dice.tscn")

var state = preload("res://game/board_state.tres")
var events = preload("res://game/events.tres") 

var diceId := 1

func _ready() -> void:
	events.turn_started.connect(determineDie)

func determineDie() -> Dice:
	var dice = diceScene.instantiate()
	dice.init(diceId)
	diceId += 1
	return dice
