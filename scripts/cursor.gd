extends Node

var cursor_white = preload("res://sprites/cursor_white.png")
var cursor_blue = preload("res://sprites/cursor_blue.png")
var cursor_offset = Vector2(9, 9)
var cursor_tooltip
var tooltip_label
var current_modulate

func _ready():
	cursor_tooltip = get_tree().root.get_node("Node2D/CanvasLayer/CursorTooltip")
	tooltip_label = cursor_tooltip.get_node("Label")
	on_tool_change(Player.tool_mode)

func on_tool_change(tool_mode):
	current_modulate = 1
	var new_cursor
	match tool_mode:
		Player.Mode.SLOW:
			new_cursor = cursor_white
			tooltip_label.text = "social distancing"
			tooltip_label.modulate = Color(1, 1, 1)
		Player.Mode.BARRIER:
			new_cursor = cursor_blue
			tooltip_label.text = "quarantine"
			tooltip_label.modulate = Color(0, 0.16, 1)
	Input.set_custom_mouse_cursor(new_cursor, 0, cursor_offset)

func _process(delta):
	cursor_tooltip.global_position = get_viewport().get_mouse_position()
	if current_modulate > 0.0:
		cursor_tooltip.modulate = Color(1, 1, 1, current_modulate)
		current_modulate -= 0.005
