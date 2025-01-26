@tool
extends Node2D
class_name Repeat


@export var length: int = 1:
	set(x):
		length = maxi(1, x)
		update()

@export var spacing: float = 0:
	set(x):
		spacing = x
		update()

@export var images: Array[Texture2D] = []:
	set(x):
		images = x
		
		for img in images:
			if !is_instance_valid(img): continue
			if img not in weights:
				weights[img] = 1.
		
		for img in weights:
			if img not in weights:
				weights.erase(img)
		
		update()

@export var weights := {}:
	set(x):
		weights = x
		update()

var is_ready := false
func _ready() -> void:
	await get_tree().process_frame
	is_ready = true

func update() -> void:
	if !is_ready: return
	for c in get_children():
		c.queue_free()
	
	var total_weight: float = 0
	var current_x: float = 0
	
	for img in weights:
		total_weight += weights[img]
	
	for i in length:
		var sprite := Sprite2D.new()
		
		var rand := randf_range(0, total_weight)
		var weight: float = 0
		
		for img in weights:
			weight += weights[img]
			if rand <= weight:
				sprite.texture = img
				break
		
		sprite.position.x = current_x
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		current_x += sprite.texture.get_width()
		current_x += spacing

