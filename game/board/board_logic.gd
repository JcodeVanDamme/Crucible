@tool
extends Node3D
class_name BoardLogic

var emptyCubeScene = preload("res://game/cubes/empty/empty_cube.tscn")
var activeCubeScene = preload("res://game/cubes/active/active_cube.tscn")

@export var visuals : BoardVisuals

enum Edges {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

var currentCubeID := 0

var layout := {}

var currentEdge := Edges.LEFT

var selectedLane
var lastLane
var laneStart : Vector2
var laneCubes

signal edge_changed

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
	if lane < 0 || lane >= Board.dimension:
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
	
	match currentEdge:
		Edges.TOP:
			return "Top"
		Edges.RIGHT:
			return "Right"
		Edges.BOTTOM:
			return "Bottom"
		Edges.LEFT:
			return "Left"
	return "Invalid Edge"
	
func get_mouse_hit() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	var mouse = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mouse)
	var dir = cam.project_ray_normal(mouse)

	var plane = Plane(Vector3.UP, Board.cubeSize)

	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else Vector3.INF
	
func world_to_lane(pos: Vector3) -> int:
	var cell_size = Board.cubeSize + Board.spacing
	var local = pos + Vector3(Board.width * 0.5, 0, Board.width * 0.5)

	match currentEdge:
		Edges.TOP, Edges.BOTTOM:
			return int(floor(local.x / cell_size))
		Edges.LEFT, Edges.RIGHT:
			return int(floor(local.z / cell_size))
	
	return -1

func _enter_tree() -> void:
	cleanup()
	build_board()

func build_board():
	for x in range(Board.dimension):
		for y in range(Board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	if visuals:
		visuals.init()
		
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
		Edges.TOP:
			return Vector2(selectedLane, 0)
		Edges.BOTTOM:
			return Vector2(selectedLane, Board.dimension - 1)
		Edges.LEFT:
			return Vector2(0, selectedLane)
		Edges.RIGHT:
			return Vector2(Board.dimension - 1, selectedLane)
			
	return Vector2.ZERO
	
	
func addCube(matrixPos : Vector2) -> Cube:
	var cube = activeCubeScene.instantiate()
	add_child(cube)
	cube.init(cubeID(), Board.cubeSize, matrixPos)
	updateCubePosition(cube)
	return cube
		
func updateCubePosition(cube : Cube) -> void:
	var matrixPos = cube.pos()
	var xPos = (matrixPos.x * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
	var zPos = (matrixPos.y * (Board.cubeSize + Board.spacing)) - (Board.width * 0.5)
	cube.position = Vector3(
		xPos,
		0,
		zPos
	)	
		
func getPushDirection() -> Vector2:
	match currentEdge:
		Edges.TOP:
			return Vector2(0, 1)
		Edges.BOTTOM:
			return Vector2(0, -1)
		Edges.LEFT:
			return Vector2(1, 0)
		Edges.RIGHT:
			return Vector2(-1, 0)
			
	return Vector2.ZERO
	
func activateCube():
	""" Selected Cube is first in Chain """
	#if layout[laneStart.x][laneStart.y] == null:
	if layout.get(laneStart) == null:
		var cube = addCube(laneStart)
		#layout[laneStart.x][laneStart.y] = cube
		layout.set(
			laneStart,
			cube
		)
		
	else:
		""" Active Blocks before selected present """
		var chain = getActiveCubeChain()
		pushCubes(chain)
		
func getActiveCubeChain() -> Array:
	var chain = []
	var coord = laneStart
	
	while checkBounds(coord):
		#var cube = layout[coord.x][coord.y]
		var cube = layout.get(coord)
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
			#layout[originalPos.x][originalPos.y] = null
			layout.set(
				originalPos,
				null
			)
			
			""" Remove Inactive Cube which active Cube gets moved into """
			#remove_child(layout[newPos.x][newPos.y])
			remove_child(layout.get(newPos))
			
			""" Move Cube into new Position """
			#layout[newPos.x][newPos.y] = cube
			layout.set(
				newPos,
				cube
			)
			cube.setPos(newPos)
			updateCubePosition(cube)
			
		else:
			""" Cube pushed out of Matrix; delete and Skip """
			remove_child(cube)
			continue
			
	""" Append new active Cube at the Front """
	var startCube = addCube(laneStart)
	#layout[laneStart.x][laneStart.y] = startCube
	layout.set(
		laneStart,
		startCube
	)
	startCube.setSelect(true)
		
		
func cubeID() -> int:
	var id = currentCubeID
	currentCubeID += 1
	return id
		
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
