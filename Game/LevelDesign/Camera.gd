extends Camera2D

const OFFSET: float = 350


func _process(_delta: float) -> void:
	position.x = OFFSET if Global.player.facing_dir > 0 else -OFFSET

