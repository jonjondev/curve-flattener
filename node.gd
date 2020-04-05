extends RigidBody2D

export (bool) var infected

func _ready():
	$Timer.connect("timeout", self, "initiate_movement")
	connect("body_entered", self, "infect_other")
	if infected:
		infect()

func initiate_movement():
	$Timer.wait_time = rand_range(5, 10)
	apply_impulse(Vector2.ZERO, Vector2(rand_range(-100, 100), rand_range(-100, 100)))

func _process(delta):
	$Sprite.global_rotation_degrees = 0

func infect():
	infected = true
	$Sprite.modulate = Color(1, 0, 0)
	add_to_group("infected")
	Stats.report_new_infection()
	

func infect_other(other):
	if infected and other is RigidBody2D:
		other.infect()
