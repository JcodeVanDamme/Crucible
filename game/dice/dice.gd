@tool
extends Node3D
class_name Dice

@export var diceData : DiceData

@onready var label := $Label3D
@onready var meshInstance = $MeshInstance3D

var id : int
var pos : Vector2

func _ready() -> void:
	resizeMesh()

func resizeMesh() -> void:
	var aabb = meshInstance.mesh.get_aabb()
	var meshSize = aabb.size.x
	var scaleFactor = Board.cubeSize / meshSize
	meshInstance.scale = Vector3.ONE * scaleFactor	
			
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		label.look_at(Board.camera.global_position, Vector3.UP)
		
func init(id : int) -> void:
	self.id = id
	$Label3D.text = str(id)
