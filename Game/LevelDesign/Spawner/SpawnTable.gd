@tool
extends Resource
class_name SpawnTable


@export var items: Array[PackedScene] = []:
	set(x):
		items = x
		var found_items := []
		
		for item in items:
			if !is_instance_valid(item): return
			found_items.append(item.resource_path)
			if item.resource_path not in table:
				table[item.resource_path] = 1.
		
		for key in table:
			if key not in found_items:
				table.erase(key)

@export var table := {}
