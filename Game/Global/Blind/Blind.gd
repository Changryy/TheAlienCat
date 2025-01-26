extends CanvasLayer

var blind := false:
	set(x):
		blind = x
		%Black.visible = x


func _ready() -> void:
	%Black.hide()
	layer = 1025


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		blind = false

