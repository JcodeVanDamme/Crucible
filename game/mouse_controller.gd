@tool
extends Node
class_name MouseController

const edges = Edges.Edges

var currentEdge : edges
var selectedLane : int

func updateLane() -> int:
	updateMouseSelection()
	return selectedLane

func updateMouseSelection() -> void:
	var hit = get_mouse_hit()
	if hit == Vector3.INF:
		return

	var lane = world_to_lane(hit)
	if lane < 0 || lane >= Board.dimension:
		selectedLane = -1
	else:
		selectedLane = lane
		
func get_mouse_hit() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	var mouse = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mouse)
	var dir = cam.project_ray_normal(mouse)

	var plane = Plane(Vector3.UP, Board.cubeSize)

	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else Vector3.INF
	
func world_to_lane(pos: Vector3) -> int:
	var cell_size = Board.cubeSize + Board.spacing
	var local = pos + Vector3(Board.width * 0.5, 0, Board.width * 0.5)

	match currentEdge:
		edges.TOP, edges.BOTTOM:
			return int(floor(local.x / cell_size))
		edges.LEFT, edges.RIGHT:
			return int(floor(local.z / cell_size))
	
	return -1
