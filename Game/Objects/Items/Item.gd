extends CharacterBody2D
class_name Item

@export var hold_index: int = 0
@export var always_under := false

func _ready() -> void:
	if always_under:
		z_index -= 1
	
	set_meta("sprite", %Sprite)
	set_meta("hold_index", hold_index)



func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 1_000 * delta)
	move_and_slide()
