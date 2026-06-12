extends Node3D
class_name CameraHandler

const ORBIT_RADIUS := 30.0
const HEIGHT := 13.0

var board := preload("res://game/resources/global/board/board.tres")
var events = preload("res://game/resources/global/event/events.tres") 

var camera : Camera3D
var radius := 20.0
var moving := false

var directions = [
	Vector3( 1, 0, 1),
	Vector3(-1, 0, 1),
	Vector3(-1, 0,-1),
	Vector3( 1, 0,-1),
]

var currentAnchor := 0
var moveTween = Tween.new()

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	camera.global_position = getAnchorPos()
	
func _process(_delta: float) -> void:
	camera.look_at(Vector3.ZERO, Vector3.UP)

func updateAnchor(step: int) -> void:
	if moving:
		return
		
	currentAnchor = (currentAnchor + step) % 4
	if currentAnchor < 0:
		currentAnchor += 4

	if moveTween:
		moveTween.kill()

	moveTween = create_tween()
	moveTween.set_trans(Tween.TRANS_SINE)
	moveTween.set_ease(Tween.EASE_IN_OUT)
	
	moveTween.tween_property(
		camera,
		"global_position",
		getAnchorPos(),
		0.6
	)
	
	moving = true
	
	moveTween.finished.connect(func():
		moving = false
		)

func getAnchorPos() -> Vector3:
	var dir = directions[currentAnchor].normalized()
	return Vector3(
		dir.x * ORBIT_RADIUS,
		HEIGHT,
		dir.z * ORBIT_RADIUS
	)
