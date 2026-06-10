extends Node
class_name TurnManager

@export var board : BoardController
@export var state : BoardState
@export var mouseController : MouseController
@export var diceSupplier : DiceSupplier
@export var cameraController : CameraController
@export var tileRenderer : TileRenderer
@export var cubeRenderer : CubeRenderer

var selectionMade : bool

func _ready() -> void:
	board.state = state
	diceSupplier.state = state
	mouseController.state = state
	tileRenderer.state = state
	cubeRenderer.state = state
	
	board.buildBoard()
	cubeRenderer.init()
	tileRenderer.buildTiles()
	
	board.cubeMoved.connect(func(id : int):
		cubeRenderer.updateDicePosition(id)
		)
	board.cubeLeftBoard.connect(func(id : int):
		cubeRenderer.deleteDice(id)
		)
	board.finished.connect(func():
		initTurn()
		)
	diceSupplier.determinedDie.connect(func():
		cubeRenderer.spawnCube()
		)
	mouseController.selectedNewLane.connect(func():
		tileRenderer.highlightLane()
		cubeRenderer.previewCurrentDie()
		)
	mouseController.selectedNoLane.connect(func():
		tileRenderer.clearLaneHighlight()
		cubeRenderer.hideDiePreview()
		)
	
	initTurn()

func _process(delta: float) -> void:
	updateTurn()
	
func initTurn() -> void:
	selectionMade = false
	state.currentDice = null
	state.laneSelected = false
	tileRenderer.clearLaneHighlight()
	diceSupplier.determineDie()
	
func updateTurn() -> void:
	if !selectionMade:
		mouseController.updateMouseSelection()
	checkInput()
	
func checkInput():
	if Input.is_action_just_pressed("confirm"):
		if !selectionMade && state.laneSelected:
			selectionMade = true
		elif selectionMade && state.laneSelected:
			board.activateCube()
			
	elif Input.is_action_just_pressed("abort") && selectionMade:
		selectionMade = false
		
	if Input.is_action_just_pressed("cycle_left") && !Input.is_action_pressed("alternate"):
		state.updateEdge(true)
		
	elif Input.is_action_just_pressed("cycle_left"):
		cameraController.updateAnchor(1)
		
	if Input.is_action_just_pressed("cycle_right") && !Input.is_action_pressed("alternate"):
		state.updateEdge(false)
		
	elif Input.is_action_just_pressed("cycle_right"):
		cameraController.updateAnchor(-1)
