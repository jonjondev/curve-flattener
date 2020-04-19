extends Control

func _ready():
	add_child(SceneManager.graph)
	$Graph.anchor_left = 0.625
	$Graph.anchor_top = 0.1
	$Graph.anchor_right = 0.9
	$Graph.anchor_bottom = 0.9
