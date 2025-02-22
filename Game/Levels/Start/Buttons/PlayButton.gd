@tool
extends Button

enum ButtonState {
	None,
	Idle,
	Hovered,
	Pressed,
	Explode
}


@export var texture: Texture2D:
	set(x):
		if !has_node("%Texture"): return
		texture = x
		%Texture.texture = x

@export var shadow: Texture2D:
	set(x):
		if !has_node("%Shadow"): return
		shadow = x
		%Shadow.texture = x

@export_group("Animation")
@export var state := ButtonState.None
@export var idle_noise: FastNoiseLite
@export var idle_amp: float = 10
@export var hover_noise: FastNoiseLite
@export var hover_amp: float = 10

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	for x in [idle_noise, hover_noise]:
		x.seed = randi()
		x.offset.x = randi_range(-500, 500)
		x.offset.y = randi_range(-500, 500)
	
	state = ButtonState.Idle


func _process(_delta: float) -> void:
	if !Engine.is_editor_hint() and state != ButtonState.Explode and !disabled:
		if button_pressed:
			state = ButtonState.Pressed
		elif is_hovered():
			state = ButtonState.Hovered
		else:
			state = ButtonState.Idle
	
	
	%Offset.position = get_rect().size / 2.
	
	match state:
		ButtonState.Idle:
			%Shadow.show()
			%Texture.z_index = 0
			%Texture.scale = Vector2.ONE
			%Texture.position.x = idle_noise.get_noise_2d(Time.get_ticks_msec(), 0) * idle_amp
			%Texture.position.y = idle_noise.get_noise_2d(0, Time.get_ticks_msec()) * idle_amp
		ButtonState.Hovered:
			%Shadow.show()
			%Texture.z_index = 1
			%Texture.scale = Vector2.ONE * 1.1
			%Texture.position.x = hover_noise.get_noise_2d(Time.get_ticks_msec(), 0) * hover_amp
			%Texture.position.y = hover_noise.get_noise_2d(0, Time.get_ticks_msec()) * hover_amp
		ButtonState.Pressed:
			%Shadow.hide()
			%Texture.z_index = -1
			%Texture.scale = Vector2.ONE * 1.
			%Texture.position = %ShadowTransform.position

func explode() -> void:
	disabled = true
	state = ButtonState.Explode
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel()
	tween.tween_property(%Texture, "scale", Vector2.ONE * 2, .4)
	tween.tween_property(%Texture, "rotation_degrees", randf_range(-90, 90), .4)
	tween.tween_property(self, "modulate:a", 0, .4)
	await tween.finished
	queue_free()

func disable() -> void:
	disabled = true
	state = ButtonState.Idle


