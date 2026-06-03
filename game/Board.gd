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
		
var currentCubeID := 0
var boardWidth : float
var cubeMatrix: = {}
var edgeCoords: Array[Vector2] = []
var currentEdgeIndex := 0
var currentCoord : Vector2
var currentDir : Vector2
var outlined_cube : Cube

func cleanup() -> void:
	cubeMatrix.clear()
	edgeCoords.clear()
	for child in get_children():
		child.queue_free()

func _enter_tree() -> void:
	build_board()

func build_board():
	cleanup()
	boardWidth = (cubeCount - 1) * cubeSpacing

	for i in range(cubeCount):
		for j in range(cubeCount):
			
			var cube = addCube(Vector2(i, j))
			cubeMatrix.set(
				Vector2(i,j),
				cube
			)
			
	buildEdgeCoords()
	
func addCube(matrixPos : Vector2) -> Cube:
	var cube = cubeScene.instantiate()
	add_child(cube)
	cube.pos = matrixPos
	cube.setSize(cubeSize)
	updateCubePosition(cube)
	return cube
	
func buildEdgeCoords():
	var maxIdx = cubeCount - 1

	""" Top row """
	for x in range(cubeCount):
		edgeCoords.append(Vector2(x, 0))

	""" Right column """
	for y in range(1, maxIdx):
		edgeCoords.append(Vector2(maxIdx, y))

	""" Bottom row """
	for x in range(maxIdx, -1, -1):
		edgeCoords.append(Vector2(x, maxIdx))

	""" Left column """
	for y in range(maxIdx - 1, 0, -1):
		edgeCoords.append(Vector2(0, y))
		
func updateCubePosition(cube : Cube) -> void:
	var matrixPos = cube.pos
	var xPos = (matrixPos.x * (cubeSize + cubeSpacing)) - (boardWidth * 0.5)
	var zPos = (matrixPos.y * (cubeSize + cubeSpacing)) - (boardWidth * 0.5)
	cube.position = Vector3(
		xPos,
		0,
		zPos
	)	
		
func getInwardDirection() -> Vector2:
	var maxIdx = cubeCount - 1

	# Top edge → inward is down (+Z)
	if currentCoord.y == 0:
		return Vector2(0, 1)

	# Bottom edge → inward is up (-Z)
	elif currentCoord.y == maxIdx:
		return Vector2(0, -1)

	# Left edge → inward is right (+X)
	elif currentCoord.x == 0:
		return Vector2(1, 0)

	# Right edge → inward is left (-X)
	elif currentCoord.x == maxIdx:
		return Vector2(-1, 0)

	return Vector2.ZERO
		
func updateSelection(cyclingLeft : bool):
	""" De-Select current Cube """
	cubeMatrix.get(currentCoord).deSelect()
	
	""" Update Edge Index to obtain new Coord using edge Coords """
	var dir = -1 if cyclingLeft else 1
	currentEdgeIndex = wrapi(
		currentEdgeIndex + dir,
		0,
		edgeCoords.size()
	)
	currentCoord = edgeCoords[currentEdgeIndex]
	
	""" Update Direction according to given Edge """
	currentDir = getInwardDirection()
	
	""" Select current Cube """
	cubeMatrix.get(currentCoord).select()
	
func activateCube():
	""" Selected Cube is first in Chain """
	if currentCoord in edgeCoords && !cubeMatrix.get(currentCoord).active:
		print("First")
		cubeMatrix.get(currentCoord).setActive(cubeID())
		
	else:
		""" Active Blocks before selected present """
		var chain = getActiveCubeChain()
		pushCubes(chain)
		
func getActiveCubeChain() -> Array:
	var chain = []
	var coord = currentCoord
	
	while checkBounds(coord):
		var cube = cubeMatrix.get(coord)
		if cube.active:
			chain.append(cube)
			coord += currentDir
		else:
			break
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
