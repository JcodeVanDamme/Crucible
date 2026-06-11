extends Node
class_name TurnManager

var state = preload("res://game/board_state.tres") 

@export var board : BoardLogic
@export var mouseController : MouseController
@export var selectionHandler : SelectionHandler
@export var boardHandler : BoardHandler
@export var diceSupplier : DiceSupplier
@export var cameraController : CameraController
@export var boardTiles : BoardTiles
@export var boardDices : BoardDices

var selectionMade : bool

func _ready() -> void:
	selectionHandler.boardTiles = boardTiles
	
	board.buildBoard()
	boardDices.init()
	boardTiles.buildTiles()
	
	board.cubeMoved.connect(func(id : int):
		boardHandler.moveDie(id)
		)
	board.cubeLeftBoard.connect(func(id : int):
		boardHandler.deleteDie(id)
		)
	board.finished.connect(func():
		boardHandler.finished()
		initTurn()
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
	
	initTurn()

func _process(delta: float) -> void:
	updateTurn()
	
func initTurn() -> void:
	selectionMade = false
	state.isLaneSelected = false
	boardTiles.clearLaneHighlight()
	diceSupplier.determineDie()
	boardDices.spawnCube()
	
func updateTurn() -> void:
	if !selectionMade:
		mouseController.updateMouseSelection()
	checkInput()
	
func checkInput():
	if Input.is_action_just_pressed("confirm"):
		if !selectionMade && state.isLaneSelected:
			selectionMade = true
		elif selectionMade && state.isLaneSelected:
			board.activateCube()
			
	elif Input.is_action_just_pressed("abort") && selectionMade:
		selectionMade = false
		
	elif Input.is_action_just_pressed("cycle_left"):
		cameraController.updateAnchor(1)
		
	elif Input.is_action_just_pressed("cycle_right"):
		cameraController.updateAnchor(-1)
