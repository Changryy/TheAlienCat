extends Move
class_name Reposition

@export var only_y := false


func update_destination() -> void:
	if !is_instance_valid(Global.player):
		to_start()
		return
	
	destination = Global.player.global_position
	
	if only_y:
		destination.x = actor.global_position.x
	else:
		destination.x += signf(actor.global_position.x - Global.player.global_position.x) * actor.RANGE





