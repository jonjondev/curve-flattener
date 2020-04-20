extends Control

func _ready():
	$PlayButton.connect("button_up", SceneManager, "start_game")
