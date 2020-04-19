extends Control

func _ready():
	$PlayButton.connect("button_up", SceneManager, "start_game")

func _input(event):
	if event is InputEventKey and event.scancode == KEY_SPACE:
		var img = get_viewport().get_texture().get_data()
		img.flip_y()
		img.flip_x()
		img.crop(100, 100)
		img.flip_x()
		img.save_png("user://screenshot.png")
