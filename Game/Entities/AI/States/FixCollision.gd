extends State
class_name FixCollision


func physics_process(delta: float) -> void:
	super(delta)
	if !is_active(): return
	
	actor.velocity = Vector2.ZERO
	actor.move_and_slide()

