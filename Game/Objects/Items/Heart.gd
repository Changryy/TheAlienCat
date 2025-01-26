extends Item
class_name Heart

var sprite: Sprite2D

var dest_pos := Vector2.ZERO
var dest_rot: float = 0

var start_pos := Vector2.ZERO
var start_rot: float = 0

var left := false

func _ready() -> void:
	remove_from_group("trash")
	%Hitbox.disabled = true
	%Sprite.hide()
	%Sprite2.hide()
	
	sprite = %Sprite if left else %Sprite2
	dest_pos = sprite.position
	dest_rot = sprite.rotation
	
	sprite.global_position = start_pos
	sprite.global_rotation = start_rot
	
	sprite.show()
	
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_parallel()
	
	tween.tween_property(sprite, "position:x", dest_pos.x, .5)
	tween.tween_property(sprite, "position:y", dest_pos.y, .5).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "rotation", dest_rot, .5)
	tween.chain().tween_callback(func(): %Hitbox.disabled = false)



