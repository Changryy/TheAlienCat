extends Move
class_name WalkToPlayer


func update_destination() -> void:
	if !is_instance_valid(Global.player):
		to_start()
		return
	
	destination.x = Global.player.global_position.x
	destination.y = actor.global_position.y


func collided() -> void:
	to_start()



