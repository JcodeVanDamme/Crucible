@abstract
extends Resource

class_name DiceFace

enum FaceTypes  {
	NUMERIC
}

var faceType : FaceTypes

@abstract func onRoll(args)
