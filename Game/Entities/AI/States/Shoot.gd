extends State
class_name Shoot

@export var rpm: float = 600

var reload_time: float = 0
var reload: float = 0

func enter() -> void:
	reload = 0
	reload_time = 60 / rpm
	fire()
	super()

func fire() -> void:
	reload += reload_time
	var bullet := Scene.bullet.instantiate() as Bullet
	bullet.height = actor.to_local(%Barrel.global_position).y
	bullet.direction = sm.aim
	bullet.global_position = %Barrel.global_position
	actor.get_parent().add_child(bullet)

func physics_process(delta: float) -> void:
	super(delta)
	if !is_active(): return
	
	if reload > 0: reload -= delta
	else: fire()



