extends Resource
class_name FaceData

@export var upFace : DiceFace
@export var downFace : DiceFace
@export var rightFace : DiceFace
@export var leftFace: DiceFace
@export var forwardFace : DiceFace
@export var backwardFace : DiceFace

var up : DiceFace
var down : DiceFace
var right : DiceFace
var left : DiceFace
var forward : DiceFace
var backward : DiceFace

var previewUp : DiceFace
var previewDown : DiceFace
var previewRight : DiceFace
var previewLeft : DiceFace
var previewForward : DiceFace
var previewBackward : DiceFace

signal data_changed

func initialize() -> void:
	up = upFace
	down = downFace
	right = rightFace
	left = leftFace
	forward = forwardFace
	backward = backwardFace


func updateFaces(rollAxis: Vector3) -> void:
	var temp: DiceFace

	match rollAxis:
		Vector3.LEFT:
			# Roll Forward; -Y
			temp = up
			previewUp = forward
			previewForward = down
			previewDown = backward
			previewBackward = temp

		Vector3.RIGHT:
			# Roll Backward; +Y
			temp = up
			previewUp = backward
			previewBackward = down
			previewDown = forward
			previewForward = temp

		Vector3.FORWARD:
			# Roll Right; +X
			temp = up
			previewUp = left
			previewLeft = down
			previewDown = right
			previewRight = temp

		Vector3.BACK:
			# Roll Left; -X
			temp = up
			previewUp = right
			previewRight = down
			previewDown = left
			previewLeft = temp
	
	data_changed.emit()
	
func applyPreview() -> void:
	up = previewUp
	down = previewDown
	right = previewRight
	left = previewLeft
	forward = previewForward
	backward = previewBackward
	resetPreview()

func resetPreview() -> void:
	previewUp = null
	previewDown = null
	previewRight = null
	previewLeft = null
	previewForward = null
	previewBackward = null
	data_changed.emit()