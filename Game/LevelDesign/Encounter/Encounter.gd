extends Wave
class_name Encounter


@export var difficulty: int = 0

var connected: int = 0
var first_wave: Array[Enemy] = []

#static var prev_hp: int = 3

func _ready() -> void:
	await super()
	#prev_hp = Global.health
	var all_enemies: Array[Enemy] = enemies.duplicate()
	
	for x in get_children():
		if !is_instance_valid(x): continue
		if x is Wave:
			all_enemies.append_array(x.enemies)
	
	for x in enemies:
		if x.active: x.alert.connect(alert, CONNECT_ONE_SHOT)
		else: first_wave.append(x)
		x.reparent(parent)
	
	for x in all_enemies:
		if !is_instance_valid(x): continue
		if !x.has_meta("suck"): continue
		connected += 1
		x.get_meta("suck").sucked_up.connect(sucked, CONNECT_ONE_SHOT)
	

func sucked() -> void:
	connected -= 1
	if connected > 0: return
	
	var hp_lost: int = maxi(3 - Global.health, 0)
	#prev_hp = Global.health
	Global.adaptive_difficulty = (Global.adaptive_difficulty + difficulty - hp_lost + 1) / 2.



var alerted := false
func alert() -> void:
	if alerted: return
	alerted = true
	
	for x in first_wave:
		if is_instance_valid(x):
			x.activate()
	
	for x in get_children():
		if x is Wave:
			x.alert()

