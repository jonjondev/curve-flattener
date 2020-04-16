extends Control

func _ready():
	$PlayButton.connect("button_up", self, "play")

func play():
	get_tree().change_scene("res://scenes/main.tscn")
