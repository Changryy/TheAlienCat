extends VBoxContainer


var labels := {}


func _ready() -> void:
	%Menu.hide()
	%Evil.hide()
	Global.vaccumed.connect(update)
	Global.panic.connect(evil, CONNECT_ONE_SHOT)


func update() -> void:
	if Global.inventory.is_empty(): return
	%Menu.show()
	
	for x in Global.inventory:
		if x not in labels:
			var l := Label.new()
			labels[x] = l
			add_child(l)
		
		if Global.inventory[x] > 1:
			labels[x].text = "%s x%s" % [x, Global.inventory[x]]
		else:
			labels[x].text = "%s" % [x]

#func _process(_delta: float) -> void:
	#%Label.text = ["Easy", "Normal", "Hard"][Global.difficulty] + " - " + str(Global.adaptive_difficulty)


func evil() -> void:
	await get_tree().create_timer(.7).timeout
	%Evil.show()
	%Player.evil()
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Evil, "modulate:a", 0, 4)







