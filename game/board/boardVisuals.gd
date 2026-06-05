@tool
extends Node3D
class_name BoardVisuals

var tileScene = preload("res://game/board/tile.tscn")

var tiles : Array[Array] = []

func initTiles(numTiles : int, size : float, spacing : float) -> void:
	tiles.clear()

	for x in range(numTiles):
		tiles.append([])
		tiles[x].resize(numTiles)
		for y in range(numTiles):
			
			tiles[x].append(buildTile(x, y, numTiles, size, spacing))
	
func buildTile(x : int, y : int, numTiles : int, size : float, spacing : float) -> Node3D:	
		var tile = tileScene.instantiate()
		add_child(tile)
		tile.setSize(size)
		
		var totalWidth = numTiles * (size + spacing)
		var xPos = (x * (size + spacing)) - (totalWidth * 0.5)
		var zPos = (y * (size + spacing)) - (totalWidth * 0.5)
		
		tile.position = Vector3(
			xPos,
			-((size * 0.5) + spacing),
			zPos
		)
		return tile
