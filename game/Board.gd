@tool
extends Node3D

var cubeScene = preload("res://Cube.tscn")
var num_cube := 0

@export var cube_count := 8:
	set(value):
		cube_count = value
		build_board()
		
@export var cube_spacing := 1.2:
	set(value):
		cube_spacing = value
		build_board()
		
@export var cube_size := 1.0:
	set(value):
		cube_size = value
		build_board()
		
var board_width : float
var matrix: = {}
var edge_coords: Array[Vector2] = []
var edge_index := 0
var current_coord : Vector2
var current_dir : Vector2
var outlined_cube : Cube

func _enter_tree() -> void:
	build_board()

func build_board():
	cleanup()
	board_width = (cube_count - 1) * cube_spacing

	for i in range(cube_count):
		for j in range(cube_count):
			var cube = cubeScene.instantiate()
			add_child(cube)
			cube.pos = Vector2(i, j)
			cube.set_size(cube_size)
			
			update_cube_position(cube)

			"""cube.position = Vector3(
				x_position,
				0,
				z_position
			)"""
			matrix.set(
				Vector2(
					i,
					j
				),
				cube
			)
			
	build_edge_coords()
	
func build_edge_coords():
	var max_idx = cube_count - 1

	# Top row
	for x in range(cube_count):
		edge_coords.append(Vector2(x, 0))

	# Right column
	for y in range(1, max_idx):
		edge_coords.append(Vector2(max_idx, y))

	# Bottom row
	for x in range(max_idx, -1, -1):
		edge_coords.append(Vector2(x, max_idx))

	# Left column
	for y in range(max_idx - 1, 0, -1):
		edge_coords.append(Vector2(0, y))
		
func update_cube_position(cube : Cube) -> void:
	var matrix_pos = cube.pos
	var x_position = (matrix_pos.x * cube_spacing) - (board_width * 0.5)
	var z_position = (matrix_pos.y * cube_spacing) - (board_width * 0.5)
	cube.position = Vector3(
		x_position,
		0,
		z_position
	)	
		
func get_inward_direction() -> Vector2:
	var max_idx = cube_count - 1

	# Top edge → inward is down (+Z)
	if current_coord.y == 0:
		return Vector2(0, 1)

	# Bottom edge → inward is up (-Z)
	elif current_coord.y == max_idx:
		return Vector2(0, -1)

	# Left edge → inward is right (+X)
	elif current_coord.x == 0:
		return Vector2(1, 0)

	# Right edge → inward is left (-X)
	elif current_coord.x == max_idx:
		return Vector2(-1, 0)

	return Vector2.ZERO
		
func update_selection(cyclingLeft : bool):
	matrix.get(current_coord).de_select()
	var dir = -1 if cyclingLeft else 1
	edge_index = wrapi(
		edge_index + dir,
		0,
		edge_coords.size()
	)
	current_coord = edge_coords[edge_index]
	current_dir = get_inward_direction()
	matrix.get(current_coord).select()
	
func activate_cube():
	var start = current_coord
	var end_cube : Cube
	
	var chain : Array = []
	var c = start
	
	while matrix.has(c):
		var cube = matrix[c]
		
		if cube.active:
			chain.append(c)
			c += current_dir
		else:
			end_cube = cube
			break
			
	for i in range(chain.size() - 1, -1, -1):
		var cube : Cube = matrix.get(chain[i])
		
		if cube.selected:
			cube.de_select()

		var old_pos = cube.pos
		var new_pos = old_pos + current_dir
		
		if checkBounds(new_pos):
			cube.pos = new_pos

			matrix.erase(old_pos)
			matrix[new_pos] = cube

			update_cube_position(cube)
			
		else:
			cube.pos = start
			matrix.erase(old_pos)
			matrix[start] = cube
			update_cube_position(cube)
			
			return

	if end_cube != null:
		end_cube.pos = start
		matrix[start] = end_cube

		update_cube_position(end_cube)

		end_cube.set_active(num_cube)
		end_cube.select()
		num_cube += 1
		
		
func checkBounds(pos) -> bool:
	if pos.x < 0:
		return false
	if pos.x >= cube_count:
		return false
	if pos.y < 0:
		return false
	if pos.y >= cube_count:
		return false
	return true
	
func cleanup() -> void:
	matrix.clear()
	edge_coords.clear()
	for child in get_children():
		child.queue_free()
		
