extends Node3D

@onready var board: Node3D = $Board

var selected_material := StandardMaterial3D.new()
var default_material := StandardMaterial3D.new()

func _ready():
	pass
	
func _process(delta: float) -> void:
	checkInput()
	
func checkInput():
	if Input.is_action_just_pressed("cycle_right"):
		board.updateSelection(false)
		
	elif Input.is_action_just_pressed("cycle_left"):
		board.updateSelection(true)
		
	elif Input.is_action_just_pressed("fire"):
		board.activateCube()
