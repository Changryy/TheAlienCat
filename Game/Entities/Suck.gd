extends Node

signal getting_sucked
signal sucked_up

const SUCC_ACC: float = 5_000
const ROT_SPEED: float = 10

var sucked := false
var counted := false
var suck_speed: float = 0

@export var entity := ""
@export var is_alive := false
@export var spiral := true
@export var vacuum_index: int = -1
@export var free_when_sucked := true

func _ready() -> void:
	owner.set_meta("suck", self)

func _process(delta: float) -> void:
	if !sucked: return
	if counted: return
	
	var dir: Vector2 = %Middle.global_position.direction_to(Global.vacuum)
	suck_speed += delta * SUCC_ACC
	owner.translate(dir * suck_speed * delta)
	
	if spiral:
		%Middle.rotate(delta * ROT_SPEED)
		%Middle.scale = Vector2.ONE * maxf(0, %Middle.scale.x - delta * 2.)
	
	if %Middle.global_position.distance_squared_to(Global.vacuum) < pow(suck_speed * delta, 2):
		counted = true
		sucked_up.emit()
		Global.suck(entity, vacuum_index, is_alive)
		if free_when_sucked: owner.queue_free()


func suck_up() -> void:
	if owner is Enemy and owner.is_immune: return
	if sucked: return
	sucked = true
	%Hitbox.disabled = true
	if has_node("%Shadow"): get_node("%Shadow").hide()
	if owner is Enemy:
		owner.bob_height = 0
	getting_sucked.emit()
