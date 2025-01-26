@tool
extends Marker2D
class_name Spawner


@onready var end_point := $EndPoint as Marker2D
@onready var line := $EndPoint/Line as Line2D

@export var min_dist: float = 10
@export var max_dist: float = 100

@export var table: SpawnTable
@export var spawn_parent: Node2D


func _ready() -> void:
	if Engine.is_editor_hint(): return
	set_process(false)
	line.hide()

	if !is_instance_valid(table): return
	
	var total_weight: float = 0
	var dict := {}
	
	for item: PackedScene in table.items:
		if !is_instance_valid(item): continue
		if item.resource_path not in table.table: continue
		if item in dict: continue
		
		var w: float = table.table[item.resource_path]
		dict[item] = w
		total_weight += w
	
	var current_x: float = 0
	
	while current_x < end_point.position.x:
		current_x += randf_range(min_dist, max_dist)
		var y_pos := randf_range(0, end_point.position.y)
		
		var value := randf_range(0, total_weight)
		var weight_count: float = 0
		
		for item: PackedScene in dict:
			weight_count += dict[item]
			if value > weight_count: continue
			
			var node := item.instantiate() as Node2D
			node.global_position = to_global(Vector2(current_x, y_pos))
			spawn_parent.add_child(node)
			break
	
	Global.trash = get_tree().get_node_count_in_group("trash")




var last_pos := Vector2.ZERO
func _process(_delta: float) -> void:
	if !Engine.is_editor_hint(): return
	if !is_instance_valid(end_point): return
	if end_point.position == last_pos: return
	last_pos = end_point.position
	
	line.points = [
		Vector2.ZERO,
		Vector2(-end_point.position.x, 0),
		-end_point.position,
		Vector2(0, -end_point.position.y),
		Vector2.ZERO
	]
