extends VBoxContainer

var events = preload("res://game/resources/global/event/events.tres") 
var state = preload("res://game/resources/global/state/board_state.tres")

@onready var diceInfo: Control = $DiceInfo
@onready var faceInfo: Control = $FaceInfo

func _ready() -> void:
	diceInfo.visible = false
	faceInfo.visible = false
	
	events.selection_changed_edge.connect(updateSelectionInfo)
	events.selection_changed_inner.connect(updateSelectionInfo)
	events.selection_changed_none.connect(resetSelectionInfo)

	
func updateSelectionInfo() -> void:
	state.selectedDie.diceData.faces.data_changed.connect(updateSelectionInfo)

	diceInfo.visible = true
	faceInfo.visible = true
	
	diceInfo.update()
	faceInfo.update()

func resetSelectionInfo() -> void:
	diceInfo.visible = false
	faceInfo.visible = false
