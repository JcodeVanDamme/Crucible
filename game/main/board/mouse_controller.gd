extends Node
class_name MouseController

var state = preload("res://game/resources/global/state/board_state.tres")
var board = preload("res://game/resources/global/board/board.tres") 
var events = preload("res://game/resources/global/event/events.tres") 

var corners : Array
var lastSelectedCell = Vector2(-1, -1)

var selectionLocked := false

func _ready() -> void:
	""" Initialize Board Corners """
	corners = [
		Vector2(0, 0),
		Vector2(0, board.dimension - 1),
		Vector2(board.dimension - 1, 0),
		Vector2(board.dimension - 1, board.dimension - 1)
	]
	
func _process(delta: float) -> void:
	if !state.selectionLocked:
		updateMouseSelection()

func updateMouseSelection() -> void:
	var cell = getHoveredCell()
	if cell != Vector2(-1, -1) && cell != lastSelectedCell:

		lastSelectedCell = cell
		
		if onEdge(cell):
			events.selection_changed_edge.emit(cell)
		else:
			events.selection_changed_inner.emit(cell)
			
	elif cell == Vector2(-1, -1):
		lastSelectedCell = null
		events.selection_changed_none.emit()
		
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
	var cellSize = board.cubeSize + board.spacing
	var local = pos + Vector3(board.width * 0.5, 0, board.width * 0.5)

	var x = int(floor(local.x / cellSize))
	var y = int(floor(local.z / cellSize))

	if x < 0 || x >= board.dimension || y < 0 || y >= board.dimension:
		return Vector2(-1, -1)

	var cell = Vector2(x, y)
		
	if corners.has(cell):
		return Vector2(-1, -1)
	
	return cell
	
func onEdge(pos : Vector2) -> bool:
	return (
		pos.x == 0 ||
		pos.x == board.dimension - 1 ||
		pos.y == 0 ||
		pos.y == board.dimension - 1
	)
