@tool
extends Node3D
class_name Cube

@onready var mesh = $MeshInstance3D

var id = null

var active := false
var selected := false
var inLane := false
var pos : Vector2

func _ready() -> void:
	$Label3D.text = ""
		
func _process(delta: float) -> void:
	if id != null:
		$Label3D.text = str(id)
		

func setActive(id : int) -> void:
	self.id = id
	active = true
	mesh.shader("active", true)

func select() -> void:
	selected = true
	
func deSelect() -> void:
	selected = false
	
func setSize(size : float) -> void:
	$MeshInstance3D.mesh.size = Vector3(
		size,
		size,
		size
	)


func _on_area_3d_mouse_entered() -> void:
	pass # Replace with function body.

func _on_area_3d_mouse_exited() -> void:
	pass # Replace with function body.
