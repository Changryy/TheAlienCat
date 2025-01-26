extends State
class_name ChangeSpeed


@export var min_speed: float = 20
@export var max_speed: float = 200

@export var min_bob: float = 3
@export var max_bob: float = 3

@export var bob_height: float = 15


func enter() -> void:
	var x := randf()
	sm.speed = lerpf(min_speed, max_speed, x)
	actor.bobs_per_second = lerpf(min_bob, max_bob, x)
	actor.bob_height = bob_height
	super()



