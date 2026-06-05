@tool
extends Node3D
class_name BoardLogic

var cubeData = preload("res://game/cubes/resources/cube_data.gd")

@export var visuals : BoardVisuals

@onready var mouseController = $MouseController as MouseController

const edges = Edges.Edges

var currentCubeID := 0

var layout := {}

var currentEdge := edges.LEFT

var selectedLane
var laneStart : Vector2

func _process(delta):
	if !Engine.is_editor_hint():
		mouseController.currentEdge = currentEdge
		selectedLane = mouseController.updateLane()
		if selectedLane != -1:
			laneStart = getLaneStart()
			if visuals:
				visuals.highlightLane(laneStart, getPushDirection())
		#processLane()
		
func updateEdge(left : bool) -> String:
	var dir = -1 if left else 1
	currentEdge = (currentEdge + dir + 4) % 4
	
	match currentEdge:
		edges.TOP:
			return "Top"
		edges.RIGHT:
			return "Right"
		edges.BOTTOM:
			return "Bottom"
		edges.LEFT:
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
		edges.TOP, edges.BOTTOM:
			return int(floor(local.x / cell_size))
		edges.LEFT, edges.RIGHT:
			return int(floor(local.z / cell_size))
	
	return -1

func build_board():
	layout.clear()

	for x in range(Board.dimension):
		for y in range(Board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	if visuals:
		visuals.init()
	
func getLaneStart() -> Vector2:
	match currentEdge:
		edges.TOP:
			return Vector2(selectedLane, 0)
		edges.BOTTOM:
			return Vector2(selectedLane, Board.dimension - 1)
		edges.LEFT:
			return Vector2(0, selectedLane)
		edges.RIGHT:
			return Vector2(Board.dimension - 1, selectedLane)
			
	return Vector2.ZERO
	
	
func setCube(at : Vector2) -> CubeData:
	var data = cubeData.new()
	data.id = cubeID()
	data.pos = at
	
	layout.set(at, data)
	
	if visuals:
		visuals.spawnCube(data)
		
	return data
		
func getPushDirection() -> Vector2:
	match currentEdge:
		edges.TOP:
			return Vector2(0, 1)
		edges.BOTTOM:
			return Vector2(0, -1)
		edges.LEFT:
			return Vector2(1, 0)
		edges.RIGHT:
			return Vector2(-1, 0)
			
	return Vector2.ZERO
	
func activateCube():
	if selectedLane == -1:
		print("Cant activate when not in Lane")
		return
		
	""" Selected Cube is first in Chain """
	if layout.get(laneStart) == null:
		setCube(laneStart)
		
	else:
		""" Active Blocks before selected present """
		var chain = getActiveCubeChain()
		pushCubes(chain)
		
func getActiveCubeChain() -> Array:
	var chain = []
	var coord = laneStart
	
	while checkBounds(coord):
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
		
		var originalPos = cube.pos
		var newPos = originalPos + getPushDirection()
		
		""" Cube not pushed outside Matrix """
		if checkBounds(newPos):
			
			moveCube(originalPos, newPos)
			
		else:
			""" Cube pushed out of Matrix; delete and Skip """
			deleteCube(originalPos)
			continue
			
	""" Append new active Cube at the Front """
	setCube(laneStart)
	
func moveCube(from : Vector2, to : Vector2) -> void:
	var data = layout.get(from)
	data.pos = to
	
	layout.set(to, data)
	layout.set(from, null)
	
	if visuals:
		visuals.updateCubePosition(data.id)
		
func deleteCube(at : Vector2) -> void:
	var id = layout.get(at).id
	layout.set(at, null)
	if visuals:
		visuals.deleteCube(id)
		
		
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
