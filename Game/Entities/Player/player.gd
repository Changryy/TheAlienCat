extends CharacterBody2D
class_name Player

const SPEED: float = 400#300#
const ACC_TIME: float = .3
const VAC_TIME: float = 15
const FREQ: float = 36

signal placed_item
signal use_released

var holding_vacuum := false
var can_vacuum := false
var holding_item: Node

@export var right_collisions: Array[CollisionShape2D] = []
@export var left_collisions: Array[CollisionShape2D] = []
@export var vacuum: Vacuum
@export var start_with_vacuum := true
@export var heart: PackedScene
@export var has_control := true
@export var death_screen: PackedScene

var end_point: Node2D

var facing_dir: int = 1
var running := false
var invincible := false

func get_vacuum_pipe_point() -> Node2D:
	return %VacuumPipe

func _ready() -> void:
	%Health.hide()
	get_viewport().get_camera_2d().reset_smoothing()
	hide_items()
	handle_flip(facing_dir, true)
	Global.player = self
	Global.vacuum_sprite.connect(vacuum_sprite)
	Global.gained_health.connect(gained_health)
	assert(is_instance_valid(vacuum))
	
	await get_tree().process_frame
	if start_with_vacuum:
		pick_up_vacuum()
	
	#get_tree().root.get_viewport().canvas_cull_mask = 1

func evil() -> void:
	%NotAngry.hide()


func _process(delta: float) -> void:
	%Anim.advance(delta)
	Global.vacuum = %VacuumPoint.global_position
	
	if !is_instance_valid(end_point): return
	%Line.clear_points()
	
	var dist: float = %Line.global_position.distance_to(end_point.global_position)
	var dir: Vector2 = %Line.to_local(end_point.global_position).normalized()
	var amount: int = maxi(floori(dist / FREQ), 16)
	
	for i in amount:
		var current_dist := dist * i / float(amount)
		var point := dir * current_dist
		point.y += ease(1. - absf(current_dist / dist - .5) * 2., .5) * 64
		%Line.add_point(point)
	
	%Line.add_point(%Line.to_local(end_point.global_position))

func _physics_process(delta: float) -> void:
	if !has_control:
		%Particles.emitting = false
		Global.vacuuming = false
		return
	
	var dir := Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(dir * SPEED, SPEED * delta / ACC_TIME)
	handle_flip(dir.x)
	move_and_slide()
	
	var is_running := !dir.is_zero_approx()
	
	if running != is_running:
		running = is_running
		%Anim["parameters/playback"].travel("Run" if running else "Idle")
	
	if !holding_vacuum or !Input.is_action_pressed("use") or !can_vacuum:
		%Particles.emitting = false
		Global.vacuuming = false
		return
	
	Global.battery -= delta * 100 / VAC_TIME
	if Global.battery <= 0:
		Global.battery = 0
		%Particles.emitting = false
		Global.vacuuming = false
		return
	
	Global.vacuuming = true
	%Particles.emitting = true
	for x in %Vacuum.get_overlapping_bodies():
		if !is_instance_valid(x): continue
		if x.has_meta("suck"):
			x.get_meta("suck").suck_up()

func pick_up_vacuum() -> void:
	hide_items()
	%Items.get_child(4).show()
	Global.vacuum_equipped.emit()
	holding_vacuum = true
	end_point = vacuum.get_end()
	
	if Input.is_action_pressed("use"):
		await use_released
	
	can_vacuum = true


func handle_flip(dir: float, force := false) -> void:
	var s := int(signf(dir))
	
	if s == 0: return
	if !force and s == facing_dir: return
	
	facing_dir = s
	%Visuals.scale.x = s
	
	for x in right_collisions:
		x.disabled = s < 0
	
	for x in left_collisions:
		x.disabled = s > 0


func _input(event: InputEvent) -> void:
	if !has_control: return
	
	if holding_vacuum:
		if event.is_action_released("use"): use_released.emit()
		return
	
	if !event.is_action_pressed("use"): return
	if drop_item(): return
	
	for item: Node2D in %Pickup.get_overlapping_bodies():
		if !is_instance_valid(item): continue
		if not item.is_in_group("holdable"):
			if not item.is_in_group("vacuumtip"): continue
		pickup(item)
		return

func pickup(item: Node2D) -> void:
	holding_item = item
	item.get_parent().remove_child(item)
	hide_items()
	
	if item.has_meta("hold_index"):
		%Items.get_child(item.get_meta("hold_index")).show()
	else:
		%Items.get_child(0).show()
	
	if item.is_in_group("vacuumtip"):
		pick_up_vacuum()

func hide_items() -> void:
	for x in %Items.get_children():
		x.hide()

func drop_item() -> bool:
	if !is_instance_valid(holding_item): return false
	hide_items()
	
	for object: Node2D in %Pickup.get_overlapping_bodies():
		if !is_instance_valid(object): continue
		if not object.has_method("add_item"): continue
		if object.add_item(holding_item):
			holding_item = null
			placed_item.emit()
			return true
	
	holding_item.global_position = %DropPoint.global_position
	get_parent().add_child(holding_item)
	holding_item = null
	return true

func take_hit() -> void:
	if invincible: return
	invincible = true
	Global.health -= 1
	%Health.show()
	
	var sprite := [%Heart1, %Heart2, %Heart3][Global.health] as Node2D
	
	if !sprite.visible:
		sprite = [%TapedHeart1, %TapedHeart2, %TapedHeart3][Global.health] as Node2D
	
	var left := heart.instantiate() as Heart
	var right := heart.instantiate() as Heart
	left.left = true
	
	right.start_pos = sprite.global_position
	right.start_rot = sprite.global_rotation
	left.start_pos = sprite.global_position
	left.start_rot = sprite.global_rotation
	
	right.global_position = sprite.global_position + Vector2(50, 400)
	left.global_position = sprite.global_position + Vector2(-60, 420)
	
	get_parent().add_child(left)
	get_parent().add_child(right)
	
	sprite.hide()
	
	var tween2 := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween2.tween_method(func(x: float): ((%Cat as Sprite2D).material as ShaderMaterial
		).set_shader_parameter("white", x), 1., 0., .2)
	if Global.health > 0: tween2.tween_callback(func(): invincible = false).set_delay(.8)
	else: die()

var tween: Tween

func vacuum_sprite(index: int) -> void:
	if index >= %Sprites.get_child_count(): return
	var sprite := %Sprites.get_child(index) as Sprite2D
	
	for i in %Sprites.get_child_count():
		%Sprites.get_child(i).hide()
	
	%Sprites.scale = Vector2.ONE
	sprite.show()
	
	if is_instance_valid(tween) and tween.is_valid():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Sprites, "scale", Vector2.ZERO, .5)
	tween.tween_callback(sprite.hide)

func gained_health() -> void:
	var hearts := [%Heart1, %Heart2, %Heart3]
	var taped_hearts := [%TapedHeart1, %TapedHeart2, %TapedHeart3]
	
	for i in mini(3, Global.health):
		taped_hearts[i].visible = !hearts[i].visible


func wake_up() -> void:
	%Anim["parameters/playback"].travel("Wake")

var dead := false
func die(_x: Variant = null) -> void:
	if dead: return
	dead = true
	has_control = false
	Global.new_trash = get_tree().get_node_count_in_group("trash")
	
	#await get_tree().create_timer(1).timeout
	Scene.slide_to(death_screen)





