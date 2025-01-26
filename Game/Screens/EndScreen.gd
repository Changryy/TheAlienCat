extends Node2D

@export var humans: Array[String] = []
@export var polices: Array[String] = []

func _ready() -> void:
	var clean: int = roundi((1. - Global.new_trash / float(Global.trash)) * 100)
	
	var victims: int = 0
	for h in humans:
		if h in Global.inventory:
			victims += Global.inventory[h]
	
	var police: int = 0
	for h in polices:
		if h in Global.inventory:
			police += Global.inventory[h]
			victims += Global.inventory[h]
	
	%Victims.text = %Victims.text.format([victims])
	%Police.text = %Police.text.format([police])
	%Clean.text = %Clean.text.format([clean])
	%Restart.modulate.a = 0
	
	%Paper.scale = Vector2.ZERO
	%Paper.rotation_degrees = 600
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(%Paper, "scale", Vector2.ONE, 2).set_delay(.5)
	tween.tween_property(%Paper, "rotation_degrees", 0, 2).set_delay(.5)
	tween.chain().tween_callback(%Restart.show).set_delay(.5)
	tween.chain().tween_property(%Restart, "modulate:a", 1, .5)
	


func _on_restart_pressed() -> void:
	Menu.unpause()
	Global.restart()
