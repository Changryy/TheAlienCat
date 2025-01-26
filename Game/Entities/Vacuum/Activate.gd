extends Node


func _ready() -> void:
	owner.set_meta("activate", self)


func activate() -> void:
	var original_pos: float = %Middle.position.y
	%Middle.position.y -= 300
	%Middle.scale = Vector2.ONE * .5
	owner.position.y += 1000
	owner.show()
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_parallel().set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(%Middle, "scale", Vector2.ONE, .8)
	tween.tween_property(%Middle, "position:y", %Middle.position.y - 100, .3)
	tween.tween_property(%Middle, "position:y", original_pos, 1.5).set_trans(Tween.TRANS_BOUNCE).set_delay(.3)
	
	


