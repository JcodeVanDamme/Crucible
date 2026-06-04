@tool
extends Node3D

var cubeScene = preload("res://game/Cube.tscn")

@export var cubeCount := 8:
	set(value):
		cubeCount = value
		build_board()
@export var cubeSpacing := 1.2:
	set(value):
		cubeSpacing = value
		build_board()
@export var cubeSize := 1.0:
	set(value):
		cubeSize = value
		build_board()
var boardWidth : float

enum edges {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}
const EDGE_NAMES = {
	edges.TOP: "TOP",
	edges.RIGHT: "RIGHT",
	edges.BOTTOM: "BOTTOM",
	edges.LEFT: "LEFT"
}

var currentCubeID := 0

var cubeMatrix: = {}

var currentCoord : Vector2
var currentDir : Vector2

var currentEdge := edges.LEFT

var selectedLane
var lastLane
var laneCubes

func _process(delta):
	updateLane()
	processLane()
	updatePushDirection()
	
func updateLane() -> void:
	var hit = get_mouse_hit()
	if hit == Vector3.INF:
		return

	var lane = world_to_lane(hit)
	if lane < 0 || lane >= cubeCount:
		selectedLane = null
	else:
		selectedLane = lane

func cleanup() -> void:
	cubeMatrix.clear()
	for child in get_children():
		child.queue_free()
		
func updateEdge(left : bool) -> String:
	var dir = -1 if left else 1
	currentEdge = (currentEdge + dir + 4) % 4
	return EDGE_NAMES.get(currentEdge)
	
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
		edges.TOP, edges.BOTTOM:
			return int(floor(local.x / cell_size))
		edges.LEFT, edges.RIGHT:
			return int(floor(local.z / cell_size))
	
	return -1

func _enter_tree() -> void:
	build_board()

func build_board():
	cleanup()
	boardWidth = cubeCount * (cubeSize + cubeSpacing)

	for i in range(cubeCount):
		for j in range(cubeCount):
			
			var cube = addCube(Vector2(i, j))
			cubeMatrix.set(
				Vector2(i,j),
				cube
			)
		
func processLane() -> void:
	if selectedLane == lastLane:
		return

	if laneCubes:
		for c in laneCubes:
			c.deSelect()
			c.mesh.shader("in_lane", false)
		laneCubes = null

	if selectedLane == null:
		lastLane = null
		return

	# select new lane
	var cubes: Array = []

	for i in range(cubeCount):
		var cube : Cube
		
		match currentEdge:
			edges.LEFT, edges.RIGHT:
				cube = cubeMatrix.get(Vector2(i, selectedLane))
				
			edges.TOP, edges.BOTTOM:
				cube = cubeMatrix.get(Vector2(selectedLane, i))
				
		cube.mesh.shader("in_lane", true)
		cubes.append(cube)

	laneCubes = cubes

	match currentEdge:
		edges.TOP:
			currentCoord = Vector2(selectedLane, 0)

		edges.BOTTOM:
			currentCoord = Vector2(selectedLane, cubeCount - 1)

		edges.LEFT:
			currentCoord = Vector2(0, selectedLane)

		edges.RIGHT:
			currentCoord = Vector2(cubeCount - 1, selectedLane)

	lastLane = selectedLane
		
	
func addCube(matrixPos : Vector2) -> Cube:
	var cube = cubeScene.instantiate()
	add_child(cube)
	cube.pos = matrixPos
	cube.setSize(cubeSize)
	updateCubePosition(cube)
	return cube
		
func updateCubePosition(cube : Cube) -> void:
	var matrixPos = cube.pos
	var xPos = (matrixPos.x * (cubeSize + cubeSpacing)) - (boardWidth * 0.5)
	var zPos = (matrixPos.y * (cubeSize + cubeSpacing)) - (boardWidth * 0.5)
	cube.position = Vector3(
		xPos,
		0,
		zPos
	)	
		
func updatePushDirection() -> void:
	match currentEdge:
		edges.TOP:
			currentDir = Vector2(0, 1)
		edges.BOTTOM:
			currentDir = Vector2(0, -1)
		edges.LEFT:
			currentDir = Vector2(1, 0)
		edges.RIGHT:
			currentDir = Vector2(-1, 0)
	
func activateCube():
	""" Selected Cube is first in Chain """
	if !cubeMatrix.get(currentCoord).active:
		cubeMatrix.get(currentCoord).setActive(cubeID())
		
	else:
		""" Active Blocks before selected present """
		var chain = getActiveCubeChain()
		pushCubes(chain)
		
func getActiveCubeChain() -> Array:
	print(currentDir)
	
	var chain = []
	var coord = currentCoord
	
	var safeguard = 0
	while checkBounds(coord):
		if safeguard == 100:
			print("ENDLESS")
			break
		var cube = cubeMatrix.get(coord)
		if cube.active:
			chain.append(cube)
			coord += currentDir
		else:
			break
		safeguard += 1
	return chain
	
func pushCubes(chain : Array) -> void:
	""" Push Cubes in Chain from back to front """
	for i in range(chain.size() - 1, -1, -1):
		var cube = chain.get(i)
		cube.deSelect()
		
		var originalPos = cube.pos
		var newPos = originalPos + currentDir
		
		""" Cube not pushed outside Matrix """
		if checkBounds(newPos):
			
			""" Dereference Matrix Slot which Cube was moved from """
			cubeMatrix.set(originalPos, null)
			
			""" Remove Inactive Cube which active Cube gets moved into """
			remove_child(cubeMatrix.get(newPos))
			
			""" Move Cube into new Position """
			cubeMatrix.set(newPos, cube)
			cube.pos = newPos
			updateCubePosition(cube)
			
		else:
			""" Cube pushed out of Matrix; delete and Skip """
			remove_child(cube)
			continue
			
	""" Append new active Cube at the Front """
	var startCube = addCube(currentCoord)
	cubeMatrix.set(currentCoord, startCube)
	startCube.setActive(cubeID())
	startCube.select()
		
		
func cubeID() -> int:
	var id = currentCubeID
	currentCubeID += 1
	return id
		
func checkBounds(pos) -> bool:
	if pos.x < 0:
		return false
	if pos.x >= cubeCount:
		return false
	if pos.y < 0:
		return false
	if pos.y >= cubeCount:
		return false
	return true
