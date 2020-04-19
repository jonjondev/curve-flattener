extends Node

func start_game():
	get_tree().change_scene("res://scenes/main.tscn")

func end_game(stats_node):
	stats_node.get_parent().remove_child(stats_node)
	get_tree().change_scene("res://scenes/game_over.tscn")
	get_node("ColorRect").add_child(stats_node)
