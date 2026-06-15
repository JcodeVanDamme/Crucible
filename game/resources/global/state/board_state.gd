extends Resource
class_name BoardState

var positionalMatrix : Dictionary
var previewMatrix = null

var dices : Dictionary

var spawnedDie : Dice
var selectedDie : Dice

var actionQueue : Array

enum Edges {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

var currentEdge := Edges.TOP

var edgeName : String:
	get:
		match currentEdge:
			Edges.TOP:
				return "TOP"
			Edges.BOTTOM:
				return "BOTTOM"
			Edges.LEFT:
				return "LEFT"
			Edges.RIGHT:
				return "RIGHT"
		return "INVALID"

var pushDirection : Vector2:
	get:
		match currentEdge:
			Edges.TOP:
				return Vector2(0, 1)
			Edges.BOTTOM:
				return Vector2(0, -1)
			Edges.LEFT:
				return Vector2(1, 0)
			Edges.RIGHT:
				return Vector2(-1, 0)
		return Vector2.ZERO

var isLaneSelected : bool
var selectedLaneStartPos : Vector2
var selectionLocked : bool

var rollAxis: Vector3:
	get:
		match currentEdge:
			Edges.TOP:
				return Vector3.RIGHT
			Edges.BOTTOM:
				return Vector3.LEFT
			Edges.LEFT:
				return Vector3.FORWARD
			Edges.RIGHT:
				return Vector3.BACK
				
		return Vector3.ZERO
