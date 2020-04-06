extends KinematicBody2D

var speed = 100
var direction

export (bool) var infected
export (bool) var immune
var is_severe_case = false

func _ready():
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	if rand_range(1, 5) > 5:
		is_severe_case = true
	if infected:
		infect()

func _physics_process(delta):
	move(delta)

func move(delta):
	var motion = get_motion(delta)
	var collision = move_and_collide(motion)
	if collision:
		direction = -direction.reflect(collision.normal)
		move(delta)
		if collision.collider.is_in_group("node"):
			transmit(collision.collider)

func get_motion(delta):
	var velocity = direction * speed
	return velocity * delta

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
