extends CharacterBody2D
class_name Furniture


@export var item_spots: Array[Sprite2D] = []


func find_spot() -> Sprite2D:
	for spot in item_spots:
		if !is_instance_valid(spot): continue
		
		if !is_instance_valid(spot.texture):
			return spot
	
	return null

func add_item(item: Node2D) -> bool:
	if !is_instance_valid(item): return false
	if !item.has_meta("sprite"): return false
	
	var spot := find_spot()
	if !is_instance_valid(spot): return false
	
	var sprite := item.get_meta("sprite") as Sprite2D
	spot.texture = sprite.texture
	spot.translate(sprite.owner.to_local(sprite.global_position))
	spot.scale = sprite.scale
	spot.rotation = sprite.rotation
	item.queue_free()
	return true
