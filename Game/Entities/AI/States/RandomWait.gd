extends State
class_name RandomWait

@export_group("Easy", "easy_")
@export var easy_min_wait: float = 1
@export var easy_max_wait: float = 1

@export_group("Normal", "normal_")
@export var normal_min_wait: float = 1
@export var normal_max_wait: float = 1

@export_group("Hard", "hard_")
@export var hard_min_wait: float = 1
@export var hard_max_wait: float = 1


func enter() -> void:
	duration_time_based = true
	duration_easy = randf_range(easy_min_wait, easy_max_wait)
	duration_normal = randf_range(normal_min_wait, normal_max_wait)
	duration_hard = randf_range(hard_min_wait, hard_max_wait)
	super()



