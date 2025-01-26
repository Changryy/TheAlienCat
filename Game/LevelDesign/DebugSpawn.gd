extends Marker2D
class_name DebugSpawn

@export var difficulty: int = 1
@export var evil := true
@export var cat: Player
@export var vacuum: Vacuum



func _ready() -> void:
	if !OS.is_debug_build(): return
	Global.evil = true
	Global.adaptive_difficulty = difficulty
	
	var offset := vacuum.global_position - cat.global_position
	cat.global_position = global_position
	vacuum.global_position = global_position + offset
