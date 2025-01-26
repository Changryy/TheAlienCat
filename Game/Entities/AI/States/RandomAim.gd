extends Aim
class_name RandomAim



func set_aim() -> void:
	sm.aim = Vector2.RIGHT.rotated(randf_range(-PI, PI))


