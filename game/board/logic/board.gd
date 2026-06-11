@tool
extends Resource
class_name Board

signal board_changed

var dimension : int
		
var spacing : float
		
var cubeSize : float

var width : float

var camera : Camera3D

func toLocalPos(matrixPos : Vector2, yOffset : float) -> Vector3:
	var step = cubeSize + spacing
	var offset = (dimension - 1) * step * 0.5

	return Vector3(
		matrixPos.x * step - offset,
		0 + yOffset,
		matrixPos.y * step - offset
	)
