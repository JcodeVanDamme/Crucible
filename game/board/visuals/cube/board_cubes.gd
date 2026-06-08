@tool
extends Node3D
class_name BoardCubes

var cubeScene = preload("res://game/cubes/active/active_cube.tscn")

var cubes := {}

func init() -> void:
	cubes.clear()
	for child in get_children():
		remove_child(child)

func spawnCube(data : CubeData) -> void:
	var cube = cubeScene.instantiate()
	add_child(cube)
	cube.init(data)
	cubes.set(cube.data.id, cube)
	updateCubePosition(data.id)
	
func updateCubePosition(id : int) -> void:
	var cube = cubes.get(id)
	var pos = cube.data.pos
	
	var step = Board.cubeSize + Board.spacing
	var center_index = (Board.dimension - 1) * 0.5
	cube.position = Vector3(
		(pos.x - center_index) * step,
		0,
		(pos.y - center_index) * step
	)
	
func deleteCube(id : int) -> void:
	var cube = cubes.get(id)
	remove_child(cube)
	cubes.set(id, null)
