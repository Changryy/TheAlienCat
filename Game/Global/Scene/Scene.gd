extends CanvasLayer


@export var bullet: PackedScene
@export var start_scene: PackedScene

func slide_to(scene: PackedScene) -> void:
	%Slide.fill_mode = ProgressBar.FILL_BEGIN_TO_END
	
	var tween := create_tween()
	tween.tween_property(%Slide, "value", 100, .5)
	tween.tween_callback(func():
		get_tree().change_scene_to_packed(scene)
		%Slide.fill_mode = ProgressBar.FILL_END_TO_BEGIN
	)
	tween.tween_property(%Slide, "value", 0, .5)


