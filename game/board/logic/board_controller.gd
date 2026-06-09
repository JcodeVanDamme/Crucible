@tool
extends Node
class_name BoardController

var state : BoardState

signal cubeMoved(id : int)
signal cubeLeftBoard(id : int)
signal finished()

func buildBoard():
	var layout = {}
	for x in range(Board.dimension):
		for y in range(Board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	state.positionalMatrix = layout
	
func activateCube():
	if state.selectedLane == -1:
		print("Cant Push when not in Lane")
		return
		
	""" First Dice in Lane """
	if state.positionalMatrix.get(state.laneStart) == null:
		state.positionalMatrix.set(state.laneStart, state.currentDice.id)
		state.dices.get(state.currentDice.id).pos = state.laneStart
		cubeMoved.emit(state.currentDice.id)
		print("First Dice placed. Finished.")
		finished.emit()
		
	else:
		""" Dice present in Lane """
		var chain = getDiceChain()
		pushDice(chain)
		print("Continous Dice placed. Finished.")
		finished.emit()
		
func getDiceChain() -> Array:
	var chain = []
	var coord = state.laneStart
	
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
	state.positionalMatrix.set(state.laneStart, state.currentDice.id)
	state.dices.get(state.currentDice.id).pos = state.laneStart
	cubeMoved.emit(state.currentDice.id)
	
func moveDice(from : Vector2, to : Vector2) -> void:
	var id = state.positionalMatrix.get(from)
	var dice = state.dices.get(id)

	dice.pos = to
	
	state.positionalMatrix.set(to, id)
	state.positionalMatrix.set(from, null)
	cubeMoved.emit(id)
		
func deleteCube(at : Vector2) -> void:
	var id = state.positionalMatrix.get(at)
	state.dices.erase(id)
	cubeLeftBoard.emit(id)
		
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
