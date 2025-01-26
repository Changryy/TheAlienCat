extends CharacterBody2D
class_name Bullet

const SPEED: float = 1000
const CAT_HEIGHT: float = 128

var height: float = -64
var direction := Vector2.LEFT
var descend: float = 10

func _ready() -> void:
	position.y -= height
	%Middle.position.y = height
	%Shadow.position.y = -height
	
	if !is_instance_valid(Global.player): return
	var dist := global_position.distance_to(Global.player.global_position)
	var time: float = dist / SPEED
	descend = (height + CAT_HEIGHT) / time
	
	%Sprite.look_at(direction * SPEED + Vector2.UP * descend + %Sprite.global_position)

var has_hit := false

func _physics_process(delta: float) -> void:
	if ready_to_despawn: return
	if %Suck.sucked: return
	if has_hit: return
	
	velocity = direction * SPEED
	move_and_slide()
	
	%Ray.target_position = -velocity * delta
	%Ray.force_shapecast_update()
	if !%Ray.is_colliding(): return
	if !%Ray.get_collider(0).has_method("take_hit"): return
	
	has_hit = true
	var target := %Ray.get_collider(0) as PhysicsBody2D
	await get_tree().process_frame
	
	if %Suck.sucked: return
	target.take_hit()
	destroy()

func _process(delta: float) -> void:
	if ready_to_despawn: return
	%Middle.position.y -= descend * delta
	%Shadow.position.y += descend * delta
	if %Middle.position.y > 0: destroy()

func _on_timer_timeout() -> void:
	destroy()

func destroy() -> void:
	ready_to_despawn = true
	%Particles.emitting = false
	%Shadow.hide()
	%Sprite.hide()

var ready_to_despawn := false

func despawn() -> void:
	if ready_to_despawn: queue_free()

