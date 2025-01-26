extends Node2D
class_name Wave

@export var delay: float = 1

var enemies: Array[Enemy] = []
@onready var parent: Node = get_parent()

func has_y_sort(node: Node) -> bool:
	if node is Node2D:
		return node.y_sort_enabled
	return false

func _ready() -> void:
	while not has_y_sort(parent):
		parent = parent.get_parent()
	
	await parent.ready
	
	for x in get_children():
		if !is_instance_valid(x): continue
		if x is Enemy:
			enemies.append(x)
			x.reparent(parent)

func alert() -> void:
	get_tree().create_timer(delay).timeout.connect(spawn, CONNECT_ONE_SHOT)

func spawn() -> void:
	for x in enemies:
		if !is_instance_valid(x): continue
		x.activate()


