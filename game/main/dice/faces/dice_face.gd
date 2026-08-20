@abstract
extends Resource

class_name DiceFace

enum FaceTypes  {
	NUMERIC
}

var faceType:FaceTypes

@export var name:String
@export var description:String
@export var icon:Texture2D