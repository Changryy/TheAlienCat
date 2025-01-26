extends Area2D
class_name Pickup

signal picked_up

@export var active := false
@export var spawn_pos: Marker2D
var collected := false


func execute() -> void: pass

func _ready() -> void:
	if active: %Anim.play("hover")
	else:
		hide()
		%Anim.stop()


func _on_body_entered(_body: Node2D) -> void:
	if collected: return
	if !active: return
	collected = true
	%Anim.stop()
	execute()
	
	var tween := create_tween().set_parallel()
	tween.tween_property(%Sprite, "scale", Vector2.ONE * 3, 0.3)
	tween.tween_property(%Shadow, "modulate:a", 0, 0.3)
	tween.tween_property(%Sprite, "position:y", %Sprite.position.y - 100, 0.3)
	
	await tween.finished
	picked_up.emit()
	queue_free()

var spawning := false

func spawn() -> void:
	if active: return
	if collected: return
	if spawning: return
	spawning = true
	
	if is_instance_valid(spawn_pos):
		%Shadow.global_position = spawn_pos.global_position
	
	%Shadow.scale = Vector2.ZERO
	show()
	
	var tween := create_tween().set_parallel()
	tween.tween_property(%Shadow, "scale", Vector2.ONE * 1, 0.5)
	tween.tween_property(%Shadow, "position:x", 0, 0.5)
	tween.tween_property(%Shadow, "position:y", 0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	active = true
	spawning = false
	%Anim.play("hover")

