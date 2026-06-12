extends Node
class_name GameController

var state = preload("res://game/board_state.tres")
var events = preload("res://game/events.tres") 

@onready var diceSupplier := $DiceSupplier
@onready var selectionHandler := $SelectionHandler
@onready var cameraHandler := $CameraHandler
@onready var inputHandler := $InputHandler
@onready var dices := $Visuals/Dices
@onready var tiles := $Visuals/Tiles

func _ready() -> void:
	selectionHandler.boardTiles = tiles
	inputHandler.cameraHandler = cameraHandler
	
	events.turn_ended.connect(func():
		handleTurnEnd()
		)
	events.turn_started.connect(func():
		handleTurnStart()
		)
	
	await get_tree().process_frame
	events.turn_started.emit()
	
func handleTurnStart() -> void:
	initTurn()

func handleTurnEnd() -> void:
	#tiles.clearLaneHighlight()
	
	await get_tree().process_frame
	events.turn_started.emit()
	
func initTurn() -> void:
	state.selectionLocked = false
	dices.spawnCube(diceSupplier.determineDie())
	events.selection_changed_none.emit()
