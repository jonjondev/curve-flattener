extends Line2D

func set_time_alive(amount):
	$Timer.connect("timeout", self, "queue_free")
	$Timer.wait_time = amount
	$Timer.start()

func _process(delta):
	if not $Timer.is_stopped():
		modulate = Color(1, 1, 1, $Timer.time_left / $Timer.wait_time)
