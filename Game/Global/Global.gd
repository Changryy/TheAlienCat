extends Node


signal panic
signal vaccumed
@warning_ignore("unused_signal")
signal vacuum_equipped
signal vacuum_sprite(index: int)
signal gained_health

var player: Player
var vacuum := Vector2.ZERO
var battery: float = 100
var health: int = 3:
	set(x):
		if x > health:
			health = x
			gained_health.emit()
		health = x

var vacuuming := false
var inventory := {}
var trash: int = 1
var evil := false
var new_trash: int = 1
var difficulty: int = 0
var adaptive_difficulty: float = 0:
	set(x):
		adaptive_difficulty = x
		difficulty = clampi(roundi(x), 0, 2)

func suck(entity: String, index: int = -1, should_panic := false) -> void:
	if entity:
		if entity not in inventory:
			inventory[entity] = 0
		inventory[entity] += 1
		
		if index >= 0:
			vacuum_sprite.emit(index)
	
	if should_panic:
		evil = true
		panic.emit()
	
	await get_tree().process_frame
	vaccumed.emit()

func spend(entity: String, amount: int = 1) -> bool:
	if entity not in inventory: return false
	if inventory[entity] < amount: return false
	inventory[entity] -= amount
	if inventory[entity] == 0:
		inventory.erase(entity)
	
	vaccumed.emit()
	return true


func restart() -> void:
	player = null
	vacuum = Vector2.ZERO
	battery = 100
	health = 3
	vacuuming = false
	evil = false
	inventory.clear()
	trash = 1
	new_trash = 1
	adaptive_difficulty = 0
	Scene.slide_to(Scene.start_scene)

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

