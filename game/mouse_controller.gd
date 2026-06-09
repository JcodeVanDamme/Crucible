@tool
extends Node
class_name MouseController

var state : BoardState

var lastSelectedLane := -1

signal selectedNewLane()
signal selectedNoLane()

func updateMouseSelection() -> void:
	var lane = getLane()
	if lane != lastSelectedLane:
		lastSelectedLane = lane
		state.selectedLane = lane
		state.laneStart = getLaneStart()
		selectedNewLane.emit()
	elif lane == -1:
		selectedNoLane.emit()

func getLane() -> int:
	var hit = getMouseHit()
	if hit == Vector3.INF:
		return -1

	var lane = worldToLane(hit)
	if lane < 0 || lane >= Board.dimension:
		return -1
	else:
		return lane
		
func getMouseHit() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	var mouse = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mouse)
	var dir = cam.project_ray_normal(mouse)

	var plane = Plane(Vector3.UP, 0)

	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else Vector3.INF
	
func worldToLane(pos: Vector3) -> int:
	var cell_size = Board.cubeSize + Board.spacing
	var local = pos + Vector3(Board.width * 0.5, 0, Board.width * 0.5)

	match state.selectedEdge:
		state.Edges.TOP, state.Edges.BOTTOM:
			return int(floor(local.x / cell_size))
		state.Edges.LEFT, state.Edges.RIGHT:
			return int(floor(local.z / cell_size))
	
	return -1
	
func getLaneStart() -> Vector2:
	match state.selectedEdge:
		state.Edges.TOP:
			return Vector2(state.selectedLane, 0)
		state.Edges.BOTTOM:
			return Vector2(state.selectedLane, Board.dimension - 1)
		state.Edges.LEFT:
			return Vector2(0, state.selectedLane)
		state.Edges.RIGHT:
			return Vector2(Board.dimension - 1, state.selectedLane)
	return Vector2.ZERO
