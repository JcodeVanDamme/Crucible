@tool
@abstract
extends Node3D
class_name Cube

var cubeData = preload("res://game/cubes/resources/cube_data.gd")
var data : CubeData = cubeData.new()

@abstract
func spawned()

@abstract
func moved()

@abstract
func destroyed()

func _ready() -> void:
	$Label3D.text = ""
			
func _process(delta: float) -> void:
	if data.id != null:
		$Label3D.text = str(data.id)
		
func init(id : int, size : float, pos : Vector2) -> void:
	data.id = id
	data.pos = pos
	$MeshInstance3D.mesh.size = Vector3.ONE * size

func setSelect(val : bool) -> void:
	data.selected = val
	
func setPos(pos : Vector2) -> void:
	data.pos = pos
	
func pos() -> Vector2:
	return data.pos
