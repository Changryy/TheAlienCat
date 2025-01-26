extends CharacterBody2D
class_name Enemy

const RANGE: float = 1200

@warning_ignore("unused_signal")
signal alert
signal activated

var facing: int = -1
var cooldown: float = 0
var reload: float = 0
var face_player := false
var bobs_per_second: float = 3
var bob_height: float = 15
var is_immune := false
@export var active := true


func _ready() -> void:
	%Detect.disabled = !active
	%Hitbox.disabled = !active
	%Detect.shape.radius = RANGE
	handle_flip(facing, true)
	if !active: hide()

var bob_time: float = 0

func _process(delta: float) -> void:
	update_flip()
	if !has_node("%Bob"): return
	
	bob_time -= delta * bobs_per_second
	
	if bob_time < 0:
		if !velocity.is_zero_approx(): bob_time += 1
		else: bob_time = 0
	
	get_node("%Bob").position.y = lerpf(-bob_height, 0, ease(absf((bob_time * 2.) - 1.), 2)) 

func update_flip() -> void:
	if face_player and is_instance_valid(Global.player):
		handle_flip(Global.player.global_position.x - global_position.x)
	else:
		handle_flip(velocity.x)

func handle_flip(dir: float, force := false) -> void:
	var s := int(signf(dir))
	
	if s == 0: return
	if !force and s == facing: return
	
	facing = s
	%Visuals.scale.x = s


func activate() -> void:
	if active: return
	
	var front := false
	if is_instance_valid(Global.player):
		front = global_position > Global.player.global_position
	
	var current_x := position.x
	position.x += 1000 if front else -1000
	handle_flip(-1 if front else 1, true)
	show()
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", current_x, 1)
	await tween.finished
	
	active = true
	%Detect.disabled = false
	%Hitbox.disabled = false
	activated.emit()


func delete_if_friendly() -> void:
	if !Global.evil: queue_free()
