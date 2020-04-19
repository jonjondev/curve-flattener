extends Node

var graph

func start_game():
	get_tree().change_scene("res://scenes/main.tscn")

func end_game(stats):
	graph = stats.get_node("Graph")
	stats.remove_child(graph)
	get_tree().change_scene("res://scenes/game_over.tscn")
