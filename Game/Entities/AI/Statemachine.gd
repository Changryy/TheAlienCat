extends Node
class_name Statemachine

@export var sucked_state: State
@export var evil_state: State
@export var activation_state: State
@export var detection: Area2D
@export var sprites: Array[Sprite2D] = []

@onready var actor := owner as Enemy
var state: State
var aim := Vector2.ZERO
var in_range := false
var speed: float = 300

func _ready() -> void:
	assert(get_child_count() > 0)
	for x in get_children():
		assert(is_instance_valid(x))
		assert(x is State)
		x.sm = self
	
	await actor.ready
	
	if actor.has_meta("suck"):
		actor.get_meta("suck").getting_sucked.connect(go_to.bind(sucked_state))
	
	if is_instance_valid(evil_state):
		Global.panic.connect(go_to.bind(evil_state), CONNECT_ONE_SHOT)
	
	if actor.active: go_to(get_child(0))
	else: actor.activated.connect(activate, CONNECT_ONE_SHOT)

func activate() -> void:
	if is_instance_valid(activation_state):
		go_to(activation_state)
	else: go_to(get_child(0))

func go_to(new_state: State = null) -> void:
	if is_instance_valid(state): state.exit()
	state = new_state
	if is_instance_valid(state): state.enter()

func _physics_process(delta: float) -> void:
	if is_instance_valid(detection):
		in_range = detection.has_overlapping_bodies()
	if is_instance_valid(state):
		state.physics_process(delta)

func show_sprite(index: int = 0) -> void:
	if index < 0: return
	if sprites.is_empty(): return
	for i in len(sprites):
		sprites[i].visible = i == index
