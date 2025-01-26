extends State
class_name Aim


@export var lock_y := false


func enter() -> void:
	set_aim()
	if lock_y:
		sm.aim.x = signf(sm.aim.x)
		sm.aim.y = 0
	super()

func set_aim() -> void:
	if is_instance_valid(Global.player):
		sm.aim = actor.global_position.direction_to(Global.player.global_position)


