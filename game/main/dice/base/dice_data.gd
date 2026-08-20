extends Resource

class_name DiceData

@export var name : String
@export var flavor : String
@export var description : String
@export var faces : FaceData

func initialize() -> void:
	faces = faces.duplicate(true)
	faces.initialize()