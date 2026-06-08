@tool
@abstract
extends Node3D
class_name Cube

@onready var label := $Label3D
@onready var meshInstance = $MeshInstance3D

var cubeData = preload("res://game/cubes/resources/cube_data.gd")
var data : CubeData

@abstract
func spawned()

@abstract
func moved()

@abstract
func destroyed()

func _ready() -> void:
	label.text = ""
			
func _process(delta: float) -> void:
	label.look_at(Board.camera.global_position, Vector3.UP)
		
func init(data : CubeData) -> void:
	self.data = data
	label.text = str(data.id)
	meshInstance.mesh.size = Vector3.ONE * Board.cubeSize
	
func setPos(pos : Vector2) -> void:
	data.pos = pos
	
func pos() -> Vector2:
	return data.pos
