extends Control

signal edgeDecrease()
signal edgeIncrease()

var edge : String

func _process(delta: float) -> void:
	if edge:
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/EdgeLabel.text = edge

func _on_left_btt_pressed() -> void:
	emit_signal("edgeDecrease")

func _on_right_btt_pressed() -> void:
	emit_signal("edgeIncrease")
