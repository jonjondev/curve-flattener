extends Control

func _ready():
	add_child(SceneManager.graph)
	$Graph.anchor_left = 0.625
	$Graph.anchor_top = 0.2
	$Graph.anchor_right = 0.9
	$Graph.anchor_bottom = 0.49
	
	
	$StatsLabel.text = "Peak Infected: " + str($Graph.peak_infection_rate) + "%\nPopulation Uninfected: " + str($Graph.total_uninfected) + "%\nDays Since First Case: " + str($Graph.current_day)
	
	yield(VisualServer, 'frame_post_draw')
	
	var viewport_size = get_viewport().size
	var img = get_viewport().get_texture().get_data()
	img.crop($CapturePanel.rect_position.x + $CapturePanel.get_size().x, img.get_size().y - $CapturePanel.rect_position.y)
	img.flip_y()
	img.flip_x()
	img.crop(img.get_size().x - $CapturePanel.rect_position.x, $CapturePanel.get_size().y)
	img.flip_x()
	img.save_png("user://screenshot.png")
