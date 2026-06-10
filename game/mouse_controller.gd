@tool
extends Node
class_name MouseController

var state : BoardState
var corners : Array
var lastSelectedCell = Vector2(-1, -1)

signal selectionChanged()
signal selectedEdge(pos : Vector2)
signal selectedInner(pos : Vector2)
signal selectedNone()

func _ready() -> void:
	corners = [
		Vector2(0, 0),
		Vector2(0, Board.dimension - 1),
		Vector2(Board.dimension - 1, 0),
		Vector2(Board.dimension - 1, Board.dimension - 1)
	]

func updateMouseSelection() -> void:
	var cell = getHoveredCell()
	if cell != Vector2(-1, -1) && cell != lastSelectedCell:

		lastSelectedCell = cell
		
		if onEdge(cell):
			selectedEdge.emit(cell)
		else:
			selectedInner.emit(cell)
					
	elif cell == Vector2(-1, -1):
		
		lastSelectedCell = null
		selectedNone.emit()
		
func getHoveredCell() -> Vector2:
	var hit = getMouseHit()

	if hit == Vector3.INF:
		return Vector2(-1, -1)

	return worldToCell(hit)
		
func getMouseHit() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	var mouse = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mouse)
	var dir = cam.project_ray_normal(mouse)

	var plane = Plane(Vector3.UP, 0)

	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else Vector3.INF
	
func worldToCell(pos: Vector3) -> Vector2:
	var cellSize = Board.cubeSize + Board.spacing
	var local = pos + Vector3(Board.width * 0.5, 0, Board.width * 0.5)

	var x = int(floor(local.x / cellSize))
	var y = int(floor(local.z / cellSize))

	if x < 0 || x >= Board.dimension || y < 0 || y >= Board.dimension:
		return Vector2(-1, -1)

	var cell = Vector2(x, y)
		
	if corners.has(cell):
		return Vector2(-1, -1)
	
	return cell
	
func onEdge(pos : Vector2) -> bool:
	return (
		pos.x == 0 ||
		pos.x == Board.dimension - 1 ||
		pos.y == 0 ||
		pos.y == Board.dimension - 1
	)
