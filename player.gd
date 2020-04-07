extends Node

var selection_box_scene = preload("res://selection_box.tscn")

var dragging = false
var start_position
var current_selection_box

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed and not dragging:
				start_position = get_viewport().get_mouse_position()
				current_selection_box = selection_box_scene.instance()
				current_selection_box.position = start_position
				get_tree().root.add_child(current_selection_box)
				dragging = true
			elif not event.pressed and dragging:
				dragging = false
				var selected_nodes = current_selection_box.get_overlapping_bodies()
				current_selection_box.queue_free()
				for node in selected_nodes:
					if node is KinematicBody2D:
						node.reduce_speed(4, 5)

func _process(delta):
	if current_selection_box and dragging:
		current_selection_box.scale = get_viewport().get_mouse_position() - start_position
