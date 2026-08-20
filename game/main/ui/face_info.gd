extends PanelContainer

var state = preload("res://game/resources/global/state/board_state.tres")

@onready var faceIcon: TextureRect = $MarginContainer/HBoxContainer/FaceIcon
@onready var faceName: Label = $MarginContainer/HBoxContainer/FaceName

func update() -> void:
	var data: DiceFace
	
	if state.selectedDie.diceData.faces.previewUp != null:
		data = state.selectedDie.diceData.faces.previewUp
	else:
		data = state.selectedDie.diceData.faces.up
	
	faceIcon.texture = data.icon
	faceName.text = data.name
