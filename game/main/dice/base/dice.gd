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
var orientation: Basis = Basis.IDENTITY

var rotating: bool = false
var rotationAxis: Vector3
var rotationProgress: float = 0.0
var startOrientation: Basis
var targetOrientation: Basis

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
		
	if rotating:
		orientation = startOrientation.slerp(targetOrientation, rotationProgress)
		mesh.basis = orientation
	if rotationProgress >= 1.0:
		rotating = false
		orientation = targetOrientation
		
func init(cubeId: int, baseColor: Color) -> void:
	self.id = cubeId
	$MeshInstance3D.color = baseColor
	$Label3D.text = str(id)
	
func initRoll(step: int) -> void:
	rotationProgress = 0.0
	rotationAxis = state.rollAxis
	var angle: float = deg_to_rad(90 * step)
	var rot: Basis = Basis(rotationAxis, angle)
	startOrientation = orientation
	targetOrientation = rot * orientation
	rotating = true