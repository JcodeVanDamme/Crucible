@tool
extends Node
class_name BoardLogic

var board = preload("res://game/resources/global/board/board.tres")
var state = preload("res://game/resources/global/state/board_state.tres")
var events = preload("res://game/resources/global/event/events.tres")

func _ready() -> void:
	events.selection_locked.connect(assembleActionQueue)
	buildBoard()

func buildBoard():
	var layout = {}
	for x in range(board.dimension):
		for y in range(board.dimension):
			
			layout.set(Vector2(x, y), null)
			
	state.positionalMatrix = layout
	
func assembleActionQueue():
	pushDice(getDiceChain())
	events.turn_ended.emit()
		
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
	state.spawnedDie.position = board.toLocalPos(state.spawnedDie.pos, 0)
	
func moveDice(from : Vector2, to : Vector2) -> void:
	var id = state.positionalMatrix.get(from)
	var dice = state.dices.get(id)

	dice.pos = to
	
	state.positionalMatrix.set(to, id)
	state.positionalMatrix.set(from, null)
	dice.position = board.toLocalPos(dice.pos, 0)
		
func deleteCube(at : Vector2) -> void:
	var id = state.positionalMatrix.get(at)
	var die = state.dices.get(id)
	var parent = die.get_parent() as Node
	parent.remove_child(die)
		
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
