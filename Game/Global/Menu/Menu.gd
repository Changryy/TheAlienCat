extends CanvasLayer


var can_pause := true
var open := false

func _input(event: InputEvent) -> void:
	if !can_pause: return
	if event.is_action_pressed("esc"):
		if %Pause.visible: unpause()
		else: pause()


func pause() -> void:
	open = true
	get_tree().paused = true
	%Pause.popup_centered()

func unpause() -> void:
	open = false
	%Pause.hide()
	%Settings.hide()
	get_tree().paused = false


func _on_resume_pressed() -> void:
	unpause()


func _on_restart_pressed() -> void:
	unpause()
	Global.restart()


func _on_blind_mode_pressed() -> void:
	Blind.blind = true
