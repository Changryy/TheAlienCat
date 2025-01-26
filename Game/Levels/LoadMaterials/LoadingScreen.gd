extends ColorRect

@export var next_scene: PackedScene
@export var materials: Array[Material]


func _ready() -> void:
	if OS.has_feature("web"):
		await get_tree().create_timer(1).timeout
	else:
		%Label.hide()
	
	var sprites = []
	
	for m in materials:
		if m is ParticleProcessMaterial:
			var particle :=  GPUParticles2D.new()
			particle.process_material = m
			add_child(particle)
			sprites.append(particle)
			particle.emitting = true
	
	for m in materials:
		if not m is ParticleProcessMaterial:
			var sprite := ColorRect.new()
			add_child(sprite)
			sprite.size = Vector2.ONE
			sprite.material = m
			sprites.append(sprite)
	
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	Scene.slide_to(next_scene)
	
