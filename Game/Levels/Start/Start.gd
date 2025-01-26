extends Node2D

enum {
	MENU,
	START,
	CLEAN,
	PICKUP,
	VACUUM,
	CHARGE,
	WALK
}

@export var next_scene: PackedScene

var stage := MENU:
	set(x):
		stage = x
		
		var count: int = 0
		var list := [%Objectives, %Clean, %CleanLine, %Pickup, %Vacuum,%OpenCloset,
					%PickupLine, %Charge, %VacuumLine, %ChargeLine, %Walk, %OpenDoor]
		
		match x:
			CLEAN:
				%Camera.zoom = Vector2.ONE
				count = 2
			PICKUP:
				count = 6
				%VacuumCleaner.get_meta("activate").activate()
				%VacuumTip.get_meta("activate").activate()
			VACUUM:
				count = 7
			CHARGE:
				count = 9
				%Battery.spawn()
			WALK:
				count = 100
		
		for i in len(list):
			list[i].visible = i < count

var node_count: int = 1
var dust_count: int = 1


func _ready() -> void:
	Menu.can_pause = false
	%Sleeping.show()
	%Player.hide()
	var nodes := get_tree().get_nodes_in_group("holdable")
	node_count = len(nodes)
	dust_count = len(get_tree().get_nodes_in_group("Dust"))
	check_dust()
	%Clean.text = "Clean your room %s/%s" % [0, node_count]
	stage = MENU
	Global.vaccumed.connect(check_dust)
	Global.vacuum_equipped.connect(func(): stage = VACUUM)

func check_dust() -> void:
	var nodes := get_tree().get_nodes_in_group("Dust")
	%Vacuum.text = "Vacuum clean the floor %s" % [floorf((1. - len(nodes) / float(dust_count)) * 100)] + "%"
	if nodes.is_empty():
		stage = CHARGE

func _on_player_placed_item() -> void:
	if stage != CLEAN: return
	var nodes := get_tree().get_nodes_in_group("holdable")
	%Clean.text = "Clean your room %s/%s" % [node_count - len(nodes), node_count]
	if nodes.is_empty():
		stage = PICKUP


func _on_door_area_body_entered(_body: Node2D) -> void:
	if stage != WALK: return
	Scene.slide_to(next_scene)

func _on_battery_picked_up() -> void:
	stage = WALK


func _on_start_pressed() -> void:
	if stage != MENU: return
	stage = START
	%Player.visibility_changed.connect(start_animation)
	%Player.wake_up()

func start_animation() -> void:
	%Camera.make_current()
	%Camera.reset_smoothing()
	%StartCamera.make_current()
	
	%Sleeping.hide()
	%Objectives.modulate.a = 0
	
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(%Start, "modulate:a", 0, .3).set_ease(Tween.EASE_IN)
	tween.tween_property(%StartCamera, "zoom", Vector2.ONE, 2)
	tween.tween_property(%StartCamera, "position:y", 0, 2)
	tween.tween_callback(
		func():
			%Start.hide()
			%Player.has_control = true
			stage = CLEAN
			Menu.can_pause = true
	).set_delay(.5)
	
	tween.chain().tween_callback(
		func():
			%Camera.make_current()
			%Camera.reset_smoothing()
	)
	tween.chain().tween_property(%Objectives, "modulate:a", 1, .5).set_ease(Tween.EASE_OUT)


func _on_blind_mode_pressed() -> void:
	Blind.blind = true


