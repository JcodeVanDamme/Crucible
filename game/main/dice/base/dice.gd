@tool
extends Node3D
class_name Dice

@export var diceData : DiceData

@onready var label := $Label3D
@onready var mesh = $MeshInstance3D as DiceMesh

var board := preload("res://game/resources/global/board/board.tres")

var id : int
var pos : Vector2

func _ready() -> void:
	resizeMesh()

func resizeMesh() -> void:
	var aabb = mesh.mesh.get_aabb()
	var meshSize = aabb.size.x
	var scaleFactor = board.cubeSize / meshSize
	mesh.scale = Vector3.ONE * scaleFactor	
			
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		var camera = get_viewport().get_camera_3d()
		label.look_at(camera.global_position, Vector3.UP)
		
func init(id : int, color : Color) -> void:
	self.id = id
	$MeshInstance3D.color = color
	$Label3D.text = str(id)
