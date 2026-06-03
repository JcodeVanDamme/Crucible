extends Node3D

@onready var board: Node3D = $BoardRoot
@onready var info_label: Label = $CanvasLayer/Label

var selected_material := StandardMaterial3D.new()
var default_material := StandardMaterial3D.new()

func _ready():
	pass
	
func _process(delta: float) -> void:
	checkInput()
	
func checkInput():
	if Input.is_action_just_pressed("cycle_right"):
		board.update_selection(false)
		
	elif Input.is_action_just_pressed("cycle_left"):
		board.update_selection(true)
		
	elif Input.is_action_just_pressed("fire"):
		board.activate_cube()
