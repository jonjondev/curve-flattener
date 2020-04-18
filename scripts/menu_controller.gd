extends Control

func _ready():
	$PlayButton.connect("button_up", self, "play")

func play():
	get_tree().change_scene("res://scenes/main.tscn")

func _input(event):
	if event is InputEventKey and event.scancode == KEY_SPACE:
		var img = get_viewport().get_texture().get_data()
		img.flip_y()
		img.flip_x()
		img.crop(100, 100)
		img.flip_x()
		img.save_png("user://screenshot.png")
