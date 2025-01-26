extends Node
class_name State

@export var sprite: int = -1
@export var face_player := false
@export var grants_immunity := false

@export_group("Duration", "duration_")
@export var duration_immidiate := false
@export var duration_time_based := false
@export var duration_easy: float = 1
@export var duration_normal: float = 1
@export var duration_hard: float = 1

@export_group("Detection")
@export var next_if_found_player := false
@export var prev_if_lost_player := false
@export var send_alert := false

@onready var actor := owner as Enemy
var sm: Statemachine
var wait_time: float = 0

func enter() -> void:
	if !is_active(): return
	if grants_immunity:
		actor.is_immune = true
	
	if duration_time_based:
		wait_time = [duration_easy, duration_normal, duration_hard][Global.difficulty]
	
	if check_detection(): return
	
	actor.face_player = face_player
	actor.update_flip()
	sm.show_sprite(sprite)
	if send_alert: actor.alert.emit()
	if duration_immidiate: next()

func exit() -> void:
	actor.is_immune = false

func is_active() -> bool:
	return sm.state == self

func check_detection() -> bool:
	if sm.in_range:
		if next_if_found_player:
			next()
			return true
	elif prev_if_lost_player:
		prev()
		return true
	return false

func physics_process(delta: float) -> void:
	if check_detection(): return
	if !duration_time_based: return
	
	if wait_time > 0:
		wait_time -= delta
	else: next()

func to_start() -> void: sm.go_to(sm.get_child(0))
func next() -> void: jump(1)
func prev() -> void: jump(-1)
func jump(amount: int = 1) -> void:
	var i := posmod(get_index() + amount, sm.get_child_count())
	sm.go_to(sm.get_child(i))
