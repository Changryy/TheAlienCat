extends Enemy

func _ready() -> void:
	handle_flip(facing, true)
	await get_tree().process_frame
	if %SpawnCheck.has_overlapping_bodies():
		queue_free()


