extends KinematicBody2D

var full_speed = 100
var current_speed
var direction

export (bool) var infected
var immune = false
var is_severe_case = false
var speed_reduction_timer

func _ready():
	$EffectTimer.connect("timeout", self, "increase_speed")
	current_speed = full_speed
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	if rand_range(1, 5) > 5:
		is_severe_case = true
	if infected:
		infect()

func _physics_process(delta):
	move(delta)

func move(delta):
	var velocity = direction * current_speed
	var motion = velocity * delta
	var collision = move_and_collide(motion)
	if collision:
		direction = -direction.reflect(collision.normal)
		if collision.collider.is_in_group("node"):
			transmit(collision.collider)

func transmit(other):
	if infected and not other.infected:
		other.infect()
	elif not infected and other.infected:
		infect()

func infect():
	if not immune:
		infected = true
		$Sprite.modulate = Color(1, 0, 0)
		add_to_group("infected")
		var recovery_time = rand_range(10, 18)
		if is_severe_case:
			recovery_time = rand_range(21, 42)
		get_tree().create_timer(recovery_time).connect("timeout", self, "recover")

func recover():
	infected = false
	immune = true
	$Sprite.modulate = Color(0, 1, 0)
	remove_from_group("infected")
	add_to_group("immune")

func reduce_speed(reduction_modifier, effect_time):
	current_speed = full_speed / reduction_modifier
	$EffectTimer.wait_time = effect_time
	$EffectTimer.start()

func increase_speed():
	current_speed = full_speed
	$EffectTimer.stop()
