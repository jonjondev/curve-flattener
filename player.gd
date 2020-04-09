extends Node

var selection_box_scene = preload("res://selection_box.tscn")
var barrier_scene = preload("res://barrier.tscn")

enum Mode {SLOW, BARRIER}

var tool_mode = Mode.BARRIER
var dragging = false
var start_position
var current_selection_box
var current_selection_intensity

var current_selection_line

func _ready():
	var all_nodes = get_tree().get_nodes_in_group("node")
	all_nodes[rand_range(0, all_nodes.size())].infect()
	get_tree().create_timer(3).connect("timeout", self, "infect_random")

func infect_random():
	var all_nodes = get_tree().get_nodes_in_group("node")
	all_nodes[rand_range(0, all_nodes.size())].infect()

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
		tool_mode = (tool_mode + 1)%2
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed and not dragging:
			start_position = get_viewport().get_mouse_position()
			if tool_mode == Mode.SLOW:
				current_selection_box = selection_box_scene.instance()
				current_selection_box.position = start_position
				get_tree().root.add_child(current_selection_box)
			elif tool_mode == Mode.BARRIER:
				current_selection_line = barrier_scene.instance()
				current_selection_line.position = start_position
				current_selection_line.add_point(start_position)
				get_tree().root.add_child(current_selection_line)
			dragging = true
		elif not event.pressed and dragging:
			dragging = false
			if tool_mode == Mode.SLOW:
				var selected_nodes = current_selection_box.get_overlapping_bodies()
				current_selection_box.queue_free()
				for node in selected_nodes:
					if node is KinematicBody2D:
						node.reduce_speed(current_selection_intensity, 14 * ((1/current_selection_intensity) * 2))
			else:
				current_selection_line.get_node("StaticBody2D/CollisionPolygon2D").polygon = current_selection_line.points
				current_selection_line.set_time_alive(7.0 * (1 - current_selection_intensity))

func _process(delta):
	if dragging:
		if current_selection_box and tool_mode == Mode.SLOW:
			current_selection_intensity = get_effect_intensity(current_selection_box.scale)
			var decimal_percentage = 1 - 1/current_selection_intensity
			current_selection_box.modulate = Color(1, decimal_percentage, decimal_percentage, 0.5)
			current_selection_box.scale = get_viewport().get_mouse_position() - start_position
		elif current_selection_line and tool_mode == Mode.BARRIER:
			current_selection_line.points[1] = get_viewport().get_mouse_position() - current_selection_line.position
			current_selection_intensity = get_line_intensity(current_selection_line.points)

func get_effect_intensity(box_scale_coordinates):
	return (get_viewport().size.x * get_viewport().size.y) / abs(box_scale_coordinates.x * box_scale_coordinates.y)

func get_line_intensity(points):
	return points[0].distance_to(points[1]) / Vector2(get_viewport().size.x, 0).distance_to(Vector2(0, get_viewport().size.y))
