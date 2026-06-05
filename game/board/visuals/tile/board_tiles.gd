@tool
extends Node3D
class_name BoardTiles

var tileScene = preload("res://game/board/visuals/tile/Tile.tscn")

@export var tileColor : Color
@export var highlightColor : Color

var tiles := {}


var lastPos : Vector2
var lastDir : Vector2
var highlightedTiles

func buildTiles() -> void:
	tiles.clear()
	for child in get_children():
		remove_child(child)
	
	for x in range(Board.dimension):
		for y in range(Board.dimension):
			
			tiles.set(Vector2(x,y), spawnTile(x, y))
			
func spawnTile(x : int, y : int) -> Node3D:
		var tile = tileScene.instantiate()
		add_child(tile)
		tile.setSize(Board.cubeSize)
		
		var mesh := tile.get_child(0) as MeshInstance3D
		var mat := StandardMaterial3D.new()
		mat.albedo_color = tileColor
		mesh.material_override = mat

		var xPos = (x * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
		var zPos = (y * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
		
		tile.position = Vector3(
			xPos,
			-((Board.cubeSize * 0.5) + Board.spacing),
			zPos
		)
		return tile
		
func highlightLane(pos : Vector2, dir : Vector2) -> void:
	print("HIGHLGIHT")
	if lastPos == pos && lastDir == dir:
		return
		
	if highlightedTiles:
		for t in highlightedTiles:
			
			var mesh := t.get_child(0) as MeshInstance3D
			var mat := mesh.material_override as StandardMaterial3D
			mat.albedo_color = tileColor

		highlightedTiles = null

	"""if currentLane == null:
		lastLane = null
		return"""

	var laneTiles = getLaneTiles(pos, dir)
	
	for t in laneTiles:
		
		var mesh := t.get_child(0) as MeshInstance3D
		var mat := mesh.material_override as StandardMaterial3D
		mat.albedo_color = highlightColor
		
	highlightedTiles = laneTiles
	lastPos = pos
	lastDir = dir
	
func getLaneTiles(start : Vector2, dir : Vector2):
	var tilesInLane = []
	var coord = start
	
	while checkBounds(coord):
		var tile = tiles.get(coord)
		tilesInLane.append(tile)
		coord += dir
	
	return tilesInLane
	
func checkBounds(pos) -> bool:
	if pos.x < 0:
		return false
	if pos.x >= Board.dimension:
		return false
	if pos.y < 0:
		return false
	if pos.y >= Board.dimension:
		return false
	return true
