extends State
class_name Move

@export var destination := Vector2.ZERO
@export var destination_tresh: float = 8
@export var acceleration_time: float = .5

@export_group("Speed", "speed_")
@export var speed_use_global := false
@export var speed_easy: float = 400
@export var speed_normal: float = 400
@export var speed_hard: float = 400

var speed: float = 400
var true_tesh: float = 8

func enter() -> void:
	actor.velocity = Vector2.ZERO
	true_tesh = destination_tresh * destination_tresh
	speed = [speed_easy, speed_normal, speed_hard][Global.difficulty]
	if speed_use_global: speed = sm.speed
	
	update_destination()
	if !is_active(): return
	
	if actor.global_position.distance_squared_to(destination) < true_tesh:
		reached_destination()
	
	super()

func physics_process(delta: float) -> void:
	super(delta)
	if !is_active(): return
	
	update_destination()
	if !is_active(): return
	
	actor.velocity = actor.velocity.move_toward(actor.global_position.direction_to(destination) * speed, speed * delta / acceleration_time)
	if actor.move_and_slide(): collided()
	if !is_active(): return
	
	if actor.global_position.distance_squared_to(destination) < true_tesh:
		reached_destination()


func update_destination() -> void:
	pass

func collided() -> void:
	next()

func reached_destination() -> void:
	next()

