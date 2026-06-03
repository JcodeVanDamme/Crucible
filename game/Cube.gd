@tool
extends Node3D
class_name Cube

@export var show_outline := false:
	
	set(value):
		show_outline = value
		if !is_node_ready():
			return
		if value:
			select()
		else:
			deSelect()

@onready var mesh = $MeshInstance3D

var id = null
var active := false
var selected := false
var pos : Vector2

func _ready() -> void:
	$Label3D.text = ""
	if Engine.is_editor_hint():
		if show_outline:
			select()
		else:
			deSelect()
	else:
		deSelect()
		
func _process(delta: float) -> void:
	if id != null:
		$Label3D.text = str(id)
		
	if selected && mesh.material_override.next_pass == null:
			mesh.material_override.next_pass = mesh.outline_mat
	elif !selected && mesh.material_override.next_pass != null:
			mesh.material_override.next_pass = null
		

func setActive(id : int) -> void:
	self.id = id
	mesh.material_override = mesh.active_material.duplicate()
	active = true

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
