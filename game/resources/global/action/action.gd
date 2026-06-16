@abstract
extends Resource
class_name Action

var state = preload("res://game/resources/global/state/board_state.tres")
var board = preload("res://game/resources/global/board/board.tres") 
var events = preload("res://game/resources/global/event/events.tres")
var colors = preload("res://game/resources/global/color/board_colors.tres")

var executorId: int
var type: int

var previewAnimation: Callable
var reverseAnimation: Callable
var executionAnimation: Callable
