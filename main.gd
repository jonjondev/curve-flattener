extends Node2D

export (bool) var infected

func _ready():
	apply_impulse(Vector2.ZERO, Vector2(100, 100))
