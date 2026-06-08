@tool
extends Node3D
class_name BoardTiles

var tileScene = preload("res://game/board/visuals/tile/Tile.tscn")

var tiles := {}

var lastPos : Vector2
var lastDir : Vector2
var highlightedTiles

func buildTiles() -> void:
	tiles.clear()
	for child in get_children():
		remove_child(child)
	
	for x in range(-1, Board.dimension + 1, 1):
		for y in range(-1, Board.dimension + 1, 1):
			
			tiles.set(Vector2(x,y), spawnTile(x, y))
			
func spawnTile(x : int, y : int) -> Node3D:
		var tile = tileScene.instantiate()
		add_child(tile)
		tile.setSize(Board.cubeSize)
		
		var mesh := tile.get_child(0) as MeshInstance3D
		var mat := StandardMaterial3D.new()
		if onEdge(Vector2(x, y)):
			mat.albedo_color = Colors.tileEdgeColor
		else:
			mat.albedo_color = Colors.tileMainColor
		mesh.material_override = mat

		var step = Board.cubeSize + Board.spacing
		var center_index = (Board.dimension - 1) * 0.5
		var xPos = (x - center_index) * step
		var zPos = (y - center_index) * step
		
		tile.position = Vector3(
			xPos,
			-((Board.cubeSize * 0.5) + Board.spacing),
			zPos
		)
		return tile
		
func onEdge(pos : Vector2) -> bool:
	return (
		pos.x == -1 or
		pos.x == Board.dimension or
		pos.y == -1 or
		pos.y == Board.dimension
	)
		
func highlightLane(pos : Vector2, dir : Vector2) -> void:
	if lastPos == pos && lastDir == dir:
		return
		
	clearLaneHighlight()

	var laneTiles = getLaneTiles(pos, dir)
	
	for coord in laneTiles:
		var tile = tiles.get(coord)
		var mesh := tile.get_child(0) as MeshInstance3D
		var mat := mesh.material_override as StandardMaterial3D
		mat.albedo_color = Colors.highlightColor
		
	highlightedTiles = laneTiles
	lastPos = pos
	lastDir = dir
	
func clearLaneHighlight() -> void:
	if !highlightedTiles:
		return
		
	for coord in highlightedTiles:
		var tile = tiles.get(coord)
		var mesh := tile.get_child(0) as MeshInstance3D
		var mat := mesh.material_override as StandardMaterial3D
		if onEdge(coord):
			mat.albedo_color = Colors.tileEdgeColor
		else:
			mat.albedo_color = Colors.tileMainColor
		
	highlightedTiles = null
	
func getLaneTiles(start : Vector2, dir : Vector2):
	var tilesInLane = []
	var coord = start - dir
	
	while checkBounds(coord, dir):
		tilesInLane.append(coord)
		coord += dir
	
	return tilesInLane
	
func checkBounds(pos : Vector2, dir : Vector2) -> bool:
	if pos.x < -1:
		return false
	if pos.x > Board.dimension:
		return false
	if pos.y < -1:
		return false
	if pos.y > Board.dimension:
		return false
	return true
