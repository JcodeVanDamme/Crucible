extends Node

enum Edges {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

const EDGE_NAMES = {
	Edges.TOP: "Top",
	Edges.RIGHT: "Right",
	Edges.BOTTOM: "Bottom",
	Edges.LEFT: "Left"
}

func toString(edge : Edges) -> String:
	return EDGE_NAMES[edge]
