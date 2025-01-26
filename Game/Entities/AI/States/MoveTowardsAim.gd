extends Move
class_name MoveTowardsAim


func update_destination() -> void:
	destination = actor.global_position + sm.aim * 1000


