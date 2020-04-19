extends Node

var stats_node

func start_game():
	get_tree().change_scene("res://scenes/main.tscn")

func end_game(stats_node):
	stats_node.get_parent().remove_child(stats_node)
	self.stats_node = stats_node
	get_tree().change_scene("res://scenes/game_over.tscn")
