@tool
extends Node3D
class_name Cube

@onready var label := $Label3D
@onready var meshInstance = $MeshInstance3D

var cubeData = preload("res://game/cubes/cube_data.gd")
var data : CubeData

func _ready() -> void:
	label.text = ""
	resizeMesh()

func resizeMesh() -> void:
	var aabb = meshInstance.mesh.get_aabb()
	var meshSize = aabb.size.x
	var scaleFactor = Board.cubeSize / meshSize
	meshInstance.scale = Vector3.ONE * scaleFactor	
			
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		label.look_at(Board.camera.global_position, Vector3.UP)
		
func init(data : CubeData) -> void:
	self.data = data
	#label.text = str(data.id)
	#meshInstance.mesh.size = Vector3.ONE * Board.cubeSize
