extends CharacterBody2D
class_name Vacuum

const MAX_DIST: float = 300
const SHAKE: float = 2

var facing_dir: int = 1

func _ready() -> void:
	%Bar.hide()

func get_end() -> Node2D:
	return %LineConnect

func _process(_delta: float) -> void:
	if !is_instance_valid(Global.player): return
	if !Global.player.holding_vacuum: return
	%Bar.value = Global.battery
	
	var new_dir: int = int(signf(global_position.direction_to(Global.player.global_position).x))
	if new_dir and new_dir != facing_dir:
		facing_dir = new_dir
		%Visuals.scale.x = 1 if new_dir > 0 else -1
	
	
	if Global.vacuuming:
		%Bar.show()
		%Visuals.position.x = randf_range(-SHAKE, SHAKE)
		%Visuals.position.y = randf_range(-SHAKE, SHAKE)
	else:
		%Visuals.position = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if !is_instance_valid(Global.player): return
	if !Global.player.holding_vacuum: return
	
	var speed := maxf(0, global_position.distance_to(Global.player.global_position) - MAX_DIST)
	velocity = velocity.move_toward(global_position.direction_to(Global.player.global_position) * speed, delta * 1_000)
	move_and_slide()


