extends Resource

var moveAction = preload("res://game/resources/global/action/move_action.gd")
var moveOffBoardAction = preload("res://game/resources/global/action/move_off_board_action.gd")

enum ActionType {
	MOVE,
	MOVE_OFF_BOARD
}

func supply(type : ActionType) -> Action:
	match type:
		ActionType.MOVE:
			return moveAction.new()
		ActionType.MOVE_OFF_BOARD:
			return moveOffBoardAction.new()
			
	return null
