extends Node
class_name SelectionHandler

var state = preload("res://game/resources/global/state/board_state.tres")
var board = preload("res://game/resources/global/board/board.tres") 
var events = preload("res://game/resources/global/event/events.tres") 

var boardTiles : BoardTiles

func _ready() -> void:
	events.selection_changed_edge.connect(handleEdgeSelection)
	events.selection_changed_inner.connect(handleInnerSelection)
	events.selection_changed_none.connect(handleNoSelection)

func handleNoSelection() -> void:
	resetSelection()

func handleEdgeSelection(pos : Vector2) -> void:
	resetSelection()

	if pos.y == 0 && pos.x > 0:
		state.currentEdge = state.Edges.TOP
		
	elif pos.y == board.dimension - 1 && pos.x > 0:
		state.currentEdge = state.Edges.BOTTOM

	elif pos.y > 0 && pos.x == 0:
		state.currentEdge = state.Edges.LEFT
		
	elif pos.y > 0 && pos.x  == board.dimension - 1:
		state.currentEdge = state.Edges.RIGHT
		
	state.selectedLaneStartPos = pos
		
	state.selectedDie = state.spawnedDie
	state.spawnedDie.pos = pos
	state.spawnedDie.position = board.toLocalPos(state.selectedLaneStartPos, 0)
	state.spawnedDie.visible = true
	state.spawnedDie.mesh.enableOutline()
	state.isLaneSelected = true
	boardTiles.highlightLane()

func handleInnerSelection(pos : Vector2) -> void:
	resetSelection()

	var id = state.positionalMatrix.get(pos)
	if id == null:
		handleNoSelection()
		return
		
	var die = state.dices.get(id) as Dice
	
	die.mesh.enableOutline()
	state.selectedDie = die
	
func resetSelection() -> void:
	state.isLaneSelected = false
	state.spawnedDie.visible = false
	state.spawnedDie.mesh.disabelOutline()

	if state.selectedDie:
		state.selectedDie.mesh.disabelOutline()
		state.selectedDie = null
		
	boardTiles.clearLaneHighlight()
