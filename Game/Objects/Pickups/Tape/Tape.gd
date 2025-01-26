extends Pickup

@export var text := ""
@export var difficulty: int = 0

func execute() -> void:
	if Global.spend(text, 2): Global.health += 1



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if Global.health >= 3:
		queue_free()
	elif Global.difficulty > difficulty:
		queue_free()
