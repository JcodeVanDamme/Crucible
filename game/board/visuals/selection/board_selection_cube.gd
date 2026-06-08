extends Node
class_name BoardSelectionCube

var cube : Node3D

func _ready() -> void:
	initCube()
	
func initCube() -> void:
	var node = Node3D.new()
	node.visible = false
	add_child(node)
	
	var mesh = MeshInstance3D.new()
	node.add_child(mesh)
	
	var shape = BoxMesh.new()
	mesh.mesh = shape
	shape.size = Vector3.ONE * Board.cubeSize
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Colors.highlightColor
	mesh.material_override = mat
	
	cube = node
	
func previewSelectionCube(pos : Vector2, selectionDir : Vector2) -> void:
	var matrixPos = pos - selectionDir
	
	var step = Board.cubeSize + Board.spacing
	var center_index = (Board.dimension - 1) * 0.5
	
	cube.position = Vector3(
		(matrixPos.x - center_index) * step,
		0,
		(matrixPos.y - center_index) * step
	)
	cube.visible = true
	
func hideSelectionCube() -> void:
	cube.visible = false
