extends Node
class_name GameController

var state = preload("res://game/board_state.tres")
var events = preload("res://game/events.tres") 

@export var dices : BoardDices
@export var mouseController : MouseController
@export var selectionHandler : SelectionHandler
@export var diceSupplier : DiceSupplier
@export var boardTiles : BoardTiles

func _ready() -> void:
	selectionHandler.boardTiles = boardTiles	
	
	events.turn_ended.connect(func():
		handleTurnEnd()
		)
	events.turn_started.connect(func():
		handleTurnStart()
		)
		
	mouseController.selectedEdge.connect(func(pos : Vector2):
		selectionHandler.handleEdgeSelection(pos)
		)
	mouseController.selectedInner.connect(func(pos : Vector2):
		selectionHandler.handleInnerSelection(pos)
		)
	mouseController.selectedNone.connect(func():
		selectionHandler.handleNoSelection()
		)
	
	await get_tree().process_frame
	events.turn_started.emit()
	
func handleTurnStart() -> void:
	initTurn()

func handleTurnEnd() -> void:
	boardTiles.clearLaneHighlight()
	
	await get_tree().process_frame
	events.turn_started.emit()
	
func initTurn() -> void:
	state.selectionLocked = false
	state.isLaneSelected = false	
	dices.spawnCube(diceSupplier.determineDie())
