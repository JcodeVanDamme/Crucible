@tool
extends Node
class_name BoardLogic

var board = preload("res://game/board.tres")
var state = preload("res://game/board_state.tres")

signal cubeMoved(id : int)
signal cubeLeftBoard(id : int)
signal finished()

func buildBoard():
	var layout = {}
	for x in range(board.dimension):
		for y in range(board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	state.positionalMatrix = layout
	
func activateCube():
	""" First Dice in Lane """
	if state.positionalMatrix.get(state.spawnPos) == null:
		state.positionalMatrix.set(state.spawnPos, state.spawnedDie.id)
		state.dices.get(state.spawnedDie.id).pos = state.spawnPos
		cubeMoved.emit(state.spawnedDie.id)
		finished.emit()
		
	else:
		""" Dice present in Lane """
		var chain = getDiceChain()
		pushDice(chain)
		finished.emit()
		
func getDiceChain() -> Array:
	var chain = []
	var coord = state.spawnPos
	
	while checkBounds(coord):
		var id = state.positionalMatrix.get(coord)
		if id != null:
			chain.append(id)
			coord += state.pushDirection
		else:
			break
	return chain
	
func pushDice(chain : Array) -> void:
	""" Push Dice in Chain from back to front """
	for i in range(chain.size() - 1, -1, -1):
		var dice = state.dices.get(chain.get(i))
		
		var originalPos = dice.pos
		var newPos = originalPos + state.pushDirection
		
		""" Cube not pushed outside Matrix """
		if checkBounds(newPos):
			
			moveDice(originalPos, newPos)
			
		else:
			""" Cube pushed out of Matrix; delete and Skip """
			deleteCube(originalPos)
			continue
			
	""" Append new Dice at the Front """
	state.positionalMatrix.set(state.spawnPos, state.spawnedDie.id)
	state.dices.get(state.spawnedDie.id).pos = state.spawnPos
	cubeMoved.emit(state.spawnedDie.id)
	
func moveDice(from : Vector2, to : Vector2) -> void:
	var id = state.positionalMatrix.get(from)
	var dice = state.dices.get(id)

	dice.pos = to
	
	state.positionalMatrix.set(to, id)
	state.positionalMatrix.set(from, null)
	cubeMoved.emit(id)
		
func deleteCube(at : Vector2) -> void:
	var id = state.positionalMatrix.get(at)
	cubeLeftBoard.emit(id)
		
func checkBounds(pos) -> bool:
	if pos.x < 1:
		return false
	if pos.x > board.dimension - 2:
		return false
	if pos.y < 1:
		return false
	if pos.y > board.dimension - 2:
		return false
	return true
