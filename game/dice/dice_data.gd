extends Resource

class_name DiceData

@export var name : String
@export var flavor : String
@export var description : String

@export var faceY_UP : DiceFace
@export var faceY_DOWN : DiceFace
@export var faceZ_NEAR : DiceFace
@export var faceZ_FAR: DiceFace
@export var faceX_NEAR : DiceFace
@export var faceX_FAR : DiceFace

var faces : Array[DiceFace]

var upFace : DiceFace

func _ready() -> void:
	initFaces()
	
func initFaces() -> void:
	faces = [
		faceY_UP,
		faceY_DOWN,
		faceZ_NEAR,
		faceZ_FAR,
		faceX_NEAR,
		faceX_FAR
	]
