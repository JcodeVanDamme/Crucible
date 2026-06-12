@tool
extends Resource
class_name Board

signal board_changed

@export var dimension : int:
	set(value):
		dimension = value
		board_changed.emit()
		
@export var spacing : float:
	set(value):
		spacing = value
		board_changed.emit()
		
@export var cubeSize : float:
	set(value):
		cubeSize = value
		board_changed.emit()

var width : float:
	get:
		return dimension * (cubeSize + spacing)

func toLocalPos(matrixPos : Vector2, yOffset : float) -> Vector3:
	var step = cubeSize + spacing
	var offset = (dimension - 1) * step * 0.5

	return Vector3(
		matrixPos.x * step - offset,
		0 + yOffset,
		matrixPos.y * step - offset
	)
