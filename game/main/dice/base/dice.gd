@tool
extends Node3D
class_name Dice

@export var diceData : DiceData

@onready var label := $Label3D
@onready var mesh = $MeshInstance3D as DiceMesh

var board := preload("res://game/resources/global/board/board.tres")

var id : int
var pos : Vector2
var camera : Camera3D

func _ready() -> void:
	resizeMesh()
	camera = get_viewport().get_camera_3d()

func resizeMesh() -> void:
	var aabb = mesh.mesh.get_aabb()
	var meshSize = aabb.size.x
	var scaleFactor = board.cubeSize / meshSize
	mesh.scale = Vector3.ONE * scaleFactor	
			
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		label.look_at(camera.global_position, Vector3.UP)
		
func init(id : int) -> void:
	self.id = id
	$Label3D.text = str(id)
