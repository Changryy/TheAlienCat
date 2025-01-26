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
	face_player = false
	
	match state:
		IDLE:
			#show_sprite(0)
			if %Detection.has_overlapping_bodies():
				cooldown = .5
				state = REACT
		
		REACT:
			face_player = true
			#show_sprite(0)
			if cooldown > 0:
				cooldown -= delta
			else: state = WALK
		
		WALK:
			#show_sprite(0)
			dir.y = 0
			dir.x = signf(Global.player.global_position.x - global_position.x)
			
			if %Detection.has_overlapping_bodies():
				state = REPOSITION
		
		REPOSITION:
			#show_sprite(0)
			var desired_pos := Global.player.global_position
			desired_pos.x += signf(global_position.x - Global.player.global_position.x) * RANGE
			dir = global_position.direction_to(desired_pos)
			
			if !%Detection.has_overlapping_bodies():
				state = WALK
			elif global_position.distance_squared_to(desired_pos) < 16:
				cooldown = 3.8
				reload = .5
				#dir = global_position.direction_to(Global.player.global_position)
				state = SHOOT
		
		SHOOT:
			face_player = true
			#show_sprite(0)
			if cooldown > 0:
				cooldown -= delta
				if reload > 0:
					reload -= delta
				else:
					reload = .1
					#fire()
			else: state = REPOSITION
	
	velocity = velocity.move_toward(dir * SPEED, SPEED * delta / ACCEL)
	var moving := !velocity.is_zero_approx()
	if move_and_slide() and moving:
		cooldown = 3.5
		reload = .5
		state = SHOOT














