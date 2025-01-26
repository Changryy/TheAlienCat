extends Aim
class_name BounceAim



func set_aim() -> void:
	if lock_y:
		sm.aim.x = -sm.aim.x
		return
	
	var col := actor.get_last_slide_collision()
	sm.aim = sm.aim.bounce(col.get_normal())

