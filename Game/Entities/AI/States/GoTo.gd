extends State
class_name GoTo


@export var state: State

func enter() -> void:
	super()
	if !is_active(): return
	if is_instance_valid(state):
		sm.go_to(state)





















