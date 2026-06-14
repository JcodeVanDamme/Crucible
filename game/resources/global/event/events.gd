extends Resource
class_name Events

signal turn_started
signal dice_spawned

signal selection_locked
signal selection_unlocked
signal selection_executed

signal selection_changed_edge(pos : Vector2)
signal selection_changed_inner(pos : Vector2)
signal selection_changed_none

signal turn_ended

signal preview_ready
