extends Resource
class_name BoardState

var positionalMatrix : Dictionary
var dices : Dictionary

enum Edges {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

var spawnedDie : Dice
var selectedDie : Dice

var currentEdge := Edges.TOP
var pushDirection : Vector2

var isLaneSelected : bool

var selectedLaneStartPos : Vector2:
	set(value):
		selectedLaneStartPos = value
		spawnPos = selectedLaneStartPos + pushDirection
		 
var spawnPos : Vector2

func _ready() -> void:
	updatePushDirection()
	
func updatePushDirection() -> void:
	match currentEdge:
		Edges.TOP:
			pushDirection =  Vector2(0, 1)
		Edges.BOTTOM:
			pushDirection = Vector2(0, -1)
		Edges.LEFT:
			pushDirection = Vector2(1, 0)
		Edges.RIGHT:
			pushDirection = Vector2(-1, 0)
			
func edgeName() -> String:
	match currentEdge:
		Edges.TOP:
			return "TOP"
		Edges.BOTTOM:
			return "BOTTOM"
		Edges.LEFT:
			return "LEFT"
		Edges.RIGHT:
			return "RIGHT"
	return "NO VALID EDGE"
