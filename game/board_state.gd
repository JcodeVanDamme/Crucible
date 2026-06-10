@tool
extends Node
class_name BoardState

var positionalMatrix : Dictionary
var dices : Dictionary

enum Edges {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

var selectedEdge := Edges.TOP

var laneSelected : bool

var laneStart : Vector2:
	set(value):
		laneStart = value
		dicePos = laneStart + pushDirection
		 
var pushDirection : Vector2

var currentDice : Dice
var dicePos : Vector2

func _ready() -> void:
	updatePushDirection()

func updateEdge(left : bool) -> void:
	"""var dir = -1 if left else 1
	selectedEdge = (selectedEdge + dir + 4) % 4
	updatePushDirection()"""
	pass
	
func updatePushDirection() -> void:
	match selectedEdge:
		Edges.TOP:
			pushDirection =  Vector2(0, 1)
		Edges.BOTTOM:
			pushDirection = Vector2(0, -1)
		Edges.LEFT:
			pushDirection = Vector2(1, 0)
		Edges.RIGHT:
			pushDirection = Vector2(-1, 0)
			
func edgeName() -> String:
	match selectedEdge:
		Edges.TOP:
			return "TOP"
		Edges.BOTTOM:
			return "BOTTOM"
		Edges.LEFT:
			return "LEFT"
		Edges.RIGHT:
			return "RIGHT"
	return "NO VALID EDGE"
