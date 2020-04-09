extends Node

enum Mode {SLOW, BARRIER}

var selection_box_scene = preload("res://selection_box.tscn")
var barrier_scene = preload("res://barrier.tscn")

var all_nodes
var tool_mode = Mode.BARRIER
var dragging = false
var start_position
var current_selection_object
var current_selection_intensity

func _ready():
	all_nodes = get_tree().get_nodes_in_group("node")
	infect_random()
	get_tree().create_timer(3).connect("timeout", self, "infect_random")

func infect_random():
	all_nodes[rand_range(0, all_nodes.size())].infect()

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
		current_selection_object = null
		tool_mode = (tool_mode + 1)%2
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed and not dragging:
			start_position = get_viewport().get_mouse_position()
			if tool_mode == Mode.SLOW:
				current_selection_object = selection_box_scene.instance()
			elif tool_mode == Mode.BARRIER:
				current_selection_object = barrier_scene.instance()
				current_selection_object.add_point(start_position)
			current_selection_object.position = start_position
			get_tree().root.add_child(current_selection_object)
			dragging = true
		elif not event.pressed and dragging:
			dragging = false
			if tool_mode == Mode.SLOW:
				var selected_nodes = current_selection_object.get_overlapping_bodies()
				current_selection_object.queue_free()
				for node in selected_nodes:
					if node is KinematicBody2D:
						node.reduce_speed(current_selection_intensity, 14 * ((1/current_selection_intensity) * 2))
			else:
				current_selection_object.get_node("StaticBody2D/CollisionPolygon2D").polygon = current_selection_object.points
				current_selection_object.set_time_alive(7.0 * (1 - current_selection_intensity))
			current_selection_object = null

func _process(delta):
	if dragging and current_selection_object:
		if tool_mode == Mode.SLOW:
			current_selection_intensity = get_box_intensity(current_selection_object.scale)
			var decimal_percentage = 1 - 1/current_selection_intensity
			current_selection_object.modulate = Color(1, decimal_percentage, decimal_percentage, 0.5)
			current_selection_object.scale = get_viewport().get_mouse_position() - start_position
		elif tool_mode == Mode.BARRIER:
			current_selection_object.points[1] = get_viewport().get_mouse_position() - current_selection_object.position
			current_selection_intensity = get_line_intensity(current_selection_object.points)

func get_box_intensity(box_scale_coordinates):
	return (get_viewport().size.x * get_viewport().size.y) / abs(box_scale_coordinates.x * box_scale_coordinates.y)

func get_line_intensity(points):
	return points[0].distance_to(points[1]) / Vector2(get_viewport().size.x, 0).distance_to(Vector2(0, get_viewport().size.y))
