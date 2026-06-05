@tool
extends Node3D
class_name BoardLogic

var emptyCubeScene = preload("res://game/cubes/empty/empty_cube.tscn")
var activeCubeScene = preload("res://game/cubes/active/active_cube.tscn")

@export var visuals : BoardVisuals
@export var size := 8:
	set(value):
		size = value
		build_board()
@export var cubeSpacing := 1.2:
	set(value):
		cubeSpacing = value
		build_board()
@export var cubeSize := 1.0:
	set(value):
		cubeSize = value
		build_board()

const edge = Edge.Edges

var boardWidth : float
var currentCubeID := 0
var layout : Array[Array] = []
var currentEdge := edge.LEFT
var laneStart : Vector2
var selectedLane
var lastLane
var laneCubes

func _process(delta):
	if !Engine.is_editor_hint():
		updateLane()
		laneStart = getLaneStart()
		processLane()
	
func updateLane() -> void:
	var hit = get_mouse_hit()
	if hit == Vector3.INF:
		return

	var lane = world_to_lane(hit)
	if lane < 0 || lane >= size:
		selectedLane = null
	else:
		selectedLane = lane

func cleanup() -> void:
	layout.clear()
	for child in get_children():
		child.queue_free()
		
func updateEdge(left : bool) -> String:
	var dir = -1 if left else 1
	currentEdge = (currentEdge + dir + 4) % 4
	return Edge.toString(currentEdge)
	
func get_mouse_hit() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	var mouse = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mouse)
	var dir = cam.project_ray_normal(mouse)

	var plane = Plane(Vector3.UP, cubeSize)

	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else Vector3.INF
	
func world_to_lane(pos: Vector3) -> int:
	var cell_size = cubeSize + cubeSpacing
	var local = pos + Vector3(boardWidth * 0.5, 0, boardWidth * 0.5)

	match currentEdge:
		edge.TOP, edge.BOTTOM:
			return int(floor(local.x / cell_size))
		edge.LEFT, edge.RIGHT:
			return int(floor(local.z / cell_size))
	
	return -1

func _enter_tree() -> void:
	build_board()

func build_board():
	cleanup()
	boardWidth = size * (cubeSize + cubeSpacing)

	for x in range(size):
		layout.append([])
		layout[x].resize(size)
		for y in range(size):
			layout[x].append(null)
			
	if visuals:
		visuals.initTiles(size, cubeSize, cubeSpacing)
		
func processLane() -> void:
	if selectedLane == lastLane:
		return

	if laneCubes:
		for c in laneCubes:
			c.setSelect(false)
			#c.mesh.shader("in_lane", false)
		laneCubes = null

	if selectedLane == null:
		lastLane = null
		return

	# select new lane
	var cubes: Array = []


	laneCubes = cubes
	lastLane = selectedLane
	
func getLaneStart() -> Vector2:
	if !currentEdge:
		print("Current Edge Null")
		return Vector2.ZERO
	elif !selectedLane:
		print("Selected Lane Null")
		return Vector2.ZERO
		
	match currentEdge:
		edge.TOP:
			return Vector2(selectedLane, 0)
		edge.BOTTOM:
			return Vector2(selectedLane, size - 1)
		edge.LEFT:
			return Vector2(0, selectedLane)
		edge.RIGHT:
			return Vector2(size - 1, selectedLane)
			
	return Vector2.ZERO
	
	
func addCube(matrixPos : Vector2) -> Cube:
	var cube = activeCubeScene.instantiate()
	add_child(cube)
	cube.init(cubeID(), cubeSize, matrixPos)
	updateCubePosition(cube)
	return cube
		
func updateCubePosition(cube : Cube) -> void:
	var matrixPos = cube.pos()
	var xPos = (matrixPos.x * (cubeSize + cubeSpacing)) - (boardWidth * 0.5)
	var zPos = (matrixPos.y * (cubeSize + cubeSpacing)) - (boardWidth * 0.5)
	cube.position = Vector3(
		xPos,
		0,
		zPos
	)	
		
func getPushDirection() -> Vector2:
	match currentEdge:
		edge.TOP:
			return Vector2(0, 1)
		edge.BOTTOM:
			return Vector2(0, -1)
		edge.LEFT:
			return Vector2(1, 0)
		edge.RIGHT:
			return Vector2(-1, 0)
			
	return Vector2.ZERO
	
func activateCube():
	""" Selected Cube is first in Chain """
	if layout[laneStart.x][laneStart.y] == null:
		var cube = addCube(laneStart)
		layout[laneStart.x][laneStart.y] = cube
		
	else:
		""" Active Blocks before selected present """
		var chain = getActiveCubeChain()
		pushCubes(chain)
		
func getActiveCubeChain() -> Array:
	var chain = []
	var coord = laneStart
	
	while checkBounds(coord):
		var cube = layout[coord.x][coord.y]
		if cube != null:
			chain.append(cube)
			coord += getPushDirection()
		else:
			break
	return chain
	
func pushCubes(chain : Array) -> void:
	""" Push Cubes in Chain from back to front """
	for i in range(chain.size() - 1, -1, -1):
		var cube = chain.get(i)
		cube.setSelect(false)
		
		var originalPos = cube.pos()
		var newPos = originalPos + getPushDirection()
		
		""" Cube not pushed outside Matrix """
		if checkBounds(newPos):
			
			""" Dereference Matrix Slot which Cube was moved from """
			layout[originalPos.x][originalPos.y] = null
			
			""" Remove Inactive Cube which active Cube gets moved into """
			remove_child(layout[newPos.x][newPos.y])
			
			""" Move Cube into new Position """
			layout[newPos.x][newPos.y] = cube
			cube.setPos(newPos)
			updateCubePosition(cube)
			
		else:
			""" Cube pushed out of Matrix; delete and Skip """
			remove_child(cube)
			continue
			
	""" Append new active Cube at the Front """
	var startCube = addCube(laneStart)
	layout[laneStart.x][laneStart.y] = startCube
	startCube.setSelect(true)
		
		
func cubeID() -> int:
	var id = currentCubeID
	currentCubeID += 1
	return id
		
func checkBounds(pos) -> bool:
	if pos.x < 0:
		return false
	if pos.x >= size:
		return false
	if pos.y < 0:
		return false
	if pos.y >= size:
		return false
	return true
