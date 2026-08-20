extends PanelContainer

var state = preload("res://game/resources/global/state/board_state.tres")

@onready var diceName: Label = $MarginContainer/VBoxContainer/DiceName
@onready var diceDescription: Label = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/DiceDescription

func update() -> void:
	var data: DiceData = state.selectedDie.diceData
	
	diceName.text = data.name
	diceDescription.text = data.description
