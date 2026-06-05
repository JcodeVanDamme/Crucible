@tool
extends Node3D
class_name BoardVisuals

var tileScene = preload("res://game/board/tile.tscn")
var cubeScene = preload("res://game/cubes/active/active_cube.tscn")

var tiles := {}
var cubes := {}

func init() -> void:
	tiles.clear()
	cubes.clear()

	for x in range(Board.dimension):
		for y in range(Board.dimension):
			
			tiles.set(Vector2(x,y), spawnTile(x, y))
			cubes.set(Vector2(x, y), null)
	
func spawnTile(x : int, y : int) -> Node3D:
		var tile = tileScene.instantiate()
		add_child(tile)
		tile.setSize(Board.cubeSize)
		
		var xPos = (x * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
		var zPos = (y * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
		
		tile.position = Vector3(
			xPos,
			-((Board.cubeSize * 0.5) + Board.spacing),
			zPos
		)
		return tile
		
func spawnCube(data : CubeData) -> void:
	var cube = cubeScene.instantiate()
	add_child(cube)
	cube.init(data)
	cubes.set(data.pos, cube)
	
func updateCubePosition(cube : Cube) -> void:
	var pos = cube.data.pos
	cube.position = Vector3(
		(pos.x * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5),
		0,
		(pos.y * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
	)
