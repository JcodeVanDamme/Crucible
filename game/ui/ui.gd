extends Control

var edge : String

func _process(delta: float) -> void:
	if edge:
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/EdgeLabel.text = edge
