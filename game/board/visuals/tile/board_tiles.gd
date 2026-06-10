@tool
extends Node3D
class_name BoardTiles

var tileScene = preload("res://game/board/visuals/tile/Tile.tscn")

var state : BoardState

var tiles := {}
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
		
		if onEdge(Vector2(x, y)):
			mat.albedo_color = Colors.tileEdgeColor
		else:
			mat.albedo_color = Colors.tileMainColor
		mesh.material_override = mat
		
		tile.position = Board.toLocalPos(
			Vector2(x, y),
			-((Board.cubeSize * 0.5) + Board.spacing)
			)
		return tile
		
func onEdge(pos : Vector2) -> bool:
	return (
		pos.x == 0 ||
		pos.x == Board.dimension - 1 ||
		pos.y == 0 ||
		pos.y == Board.dimension - 1
	)
		
func highlightLane() -> void:
	clearLaneHighlight()
	
	var laneTiles = getLaneTiles()
	
	for coord in laneTiles:
		var tile = tiles.get(coord)
		var mesh := tile.get_child(0) as MeshInstance3D
		var mat := mesh.material_override as StandardMaterial3D
		mat.albedo_color = Colors.selectionColor
		
	highlightedTiles = laneTiles
	
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
	
func getLaneTiles():
	var tilesInLane = []
	var coord = state.selectedLaneStartPos
	
	while checkBounds(coord):
		tilesInLane.append(coord)
		coord += state.pushDirection
	
	return tilesInLane
	
func checkBounds(pos : Vector2) -> bool:
	if pos.x < 0:
		return false
	if pos.x > Board.dimension - 1:
		return false
	if pos.y < 0:
		return false
	if pos.y > Board.dimension - 1:
		return false
	return true
