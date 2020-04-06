extends RigidBody2D

export (bool) var infected
export (bool) var immune

func _ready():
	$MoveTimer.connect("timeout", self, "initiate_movement")
	connect("body_entered", self, "infect_other")
	if infected:
		infect()

func initiate_movement():
	$MoveTimer.wait_time = rand_range(5, 10)
	apply_impulse(Vector2.ZERO, Vector2(rand_range(-100, 100), rand_range(-100, 100)))

func _process(delta):
	$Sprite.global_rotation_degrees = 0

func infect_other(other):
	if infected and other is RigidBody2D:
		other.infect()

func infect():
	if not immune:
		infected = true
		$Sprite.modulate = Color(1, 0, 0)
		add_to_group("infected")
		var recovery_time = rand_range(10, 18)
		if rand_range(1, 5) > 5:
			recovery_time = rand_range(21, 42)
		get_tree().create_timer(recovery_time).connect("timeout", self, "recover")

func recover():
	infected = false
	immune = true
	$Sprite.modulate = Color(0, 1, 0)
	remove_from_group("infected")
	add_to_group("immune")
