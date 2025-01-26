extends Enemy

enum {
	IDLE,
	REACT,
	WALK,
	REPOSITION,
	SHOOT
}

const SPEED: float = 400
const ACCEL: float = .3


var state := IDLE


func get_sprites() -> Array[Sprite2D]:
	return []

func _physics_process(delta: float) -> void:
	if %Suck.sucked: return
	if !active: return
	if !is_instance_valid(Global.player): return
	
	var dir := Vector2.ZERO
	
	match state:
		IDLE:
			if %Detection.has_overlapping_bodies():
				cooldown = .5
				state = REACT
		
		REACT:
			if cooldown > 0:
				cooldown -= delta
			else: state = WALK
		
		WALK:
			dir.y = 0
			dir.x = signf(Global.player.global_position.x - global_position.x)
			
			if %Detection.has_overlapping_bodies():
				state = REPOSITION
		
		REPOSITION:
			var desired_pos := Global.player.global_position
			desired_pos.x += signf(global_position.x - Global.player.global_position.x) * RANGE
			dir = global_position.direction_to(desired_pos)
			
			if !%Detection.has_overlapping_bodies():
				state = WALK
			elif global_position.distance_squared_to(desired_pos) < 16:
				reload = 1
				state = SHOOT
		
		SHOOT:
			if reload > 0:
				reload -= delta
			else:
				#fire()
				state = REPOSITION 
	
	velocity = velocity.move_toward(dir * SPEED, SPEED * delta / ACCEL)
	var moving := !velocity.is_zero_approx()
	if move_and_slide() and moving:
		reload = 1
		state = SHOOT














