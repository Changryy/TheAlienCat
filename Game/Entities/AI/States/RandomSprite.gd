extends State
class_name RandomSprite

@export var sprites: Array[int] = []


func enter() -> void:
	sprite = sprites.pick_random()
	super()





















