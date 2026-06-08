@tool
extends Node3D
class_name BoardEdges

var tileScene = preload("res://game/board/visuals/tile/Tile.tscn")

func buildEdges() -> void:
	for child in get_children():
		child.queue_free()

	var y := -((Board.cubeSize * 0.5) + Board.spacing)
	var pitch := Board.cubeSize + Board.spacing

	for edge in range(4):
		var rangeStart := -1 if edge < 2 else 0
		var rangeEnd := Board.dimension + 1 if edge < 2 else Board.dimension

		for c in range(rangeStart, rangeEnd):
			var pos: Vector2

			match edge:
				0: pos = Vector2(c, -1)                 # top
				1: pos = Vector2(c, Board.dimension)    # bottom
				2: pos = Vector2(-1, c)                 # left
				3: pos = Vector2(Board.dimension, c)    # right

			var tile = tileScene.instantiate()
			add_child(tile)

			var mesh := tile.get_child(0) as MeshInstance3D
			var mat := StandardMaterial3D.new()
			mat.albedo_color = Colors.tileEdgeColor
			mesh.material_override = mat

			tile.setSize(Board.cubeSize)

			tile.position = Vector3(
				pos.x * pitch - Board.width * 0.5,
				y,
				pos.y * pitch - Board.width * 0.5
			)
