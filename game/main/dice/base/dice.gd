@tool
extends Node3D
class_name Dice

@export var diceData : DiceData

@onready var label: Label3D = $Label3D
@onready var mesh: DiceMesh = $MeshInstance3D

var board := preload("res://game/resources/global/board/board.tres")
var state := preload("res://game/resources/global/state/board_state.tres")

var id: int
var pos: Vector2

var tween: Tween

func _ready() -> void:
	resizeMesh()

func resizeMesh() -> void:
	var aabb: AABB = mesh.mesh.get_aabb()
	var meshSize: float = aabb.size.x
	var scaleFactor = board.cubeSize / meshSize
	mesh.scale = Vector3.ONE * scaleFactor	
			
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		var camera: Camera3D = get_viewport().get_camera_3d()
		label.look_at(camera.global_position, Vector3.UP)
		
func init(cubeId: int, baseColor: Color) -> void:
	id = cubeId
	$MeshInstance3D.color = baseColor
	$Label3D.text = str(id)

func startTween() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
