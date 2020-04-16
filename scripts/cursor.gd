extends Node

var player_controller
var cursor_white = preload("res://sprites/cursor_white.png")
var cursor_blue = preload("res://sprites/cursor_blue.png")
var cursor_offset = Vector2(9, 9)
var cursor_tooltip
var tooltip_label
var current_modulate

func _ready():
	player_controller = get_tree().root.get_node("Node2D/PlayerController")
	player_controller.connect("on_tool_change", self, "change_tool")
	cursor_tooltip = get_tree().root.get_node("Node2D/CanvasLayer/CursorTooltip")
	tooltip_label = cursor_tooltip.get_node("Label")
	change_tool()

func change_tool():
	current_modulate = 1
	var new_cursor
	match player_controller.tool_mode:
		player_controller.Mode.SLOW:
			new_cursor = cursor_white
			tooltip_label.text = "social distancing"
			tooltip_label.modulate = Color(1, 1, 1)
		player_controller.Mode.BARRIER:
			new_cursor = cursor_blue
			tooltip_label.text = "quarantine"
			tooltip_label.modulate = Color(0, 0.16, 1)
	Input.set_custom_mouse_cursor(new_cursor, 0, cursor_offset)

func _process(delta):
	cursor_tooltip.global_position = get_viewport().get_mouse_position()
	if current_modulate > 0.0:
		cursor_tooltip.modulate = Color(1, 1, 1, current_modulate)
		current_modulate -= 0.005
