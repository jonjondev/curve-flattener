extends ColorRect

var current_infections = 0
var total_population = 0
var bar_scene = preload("res://bar.tscn")

func _ready():
	$Timer.connect("timeout", self, "update_stats")

func update_stats():
	current_infections = get_tree().get_nodes_in_group("infected").size()
	total_population = get_tree().get_nodes_in_group("node").size()
	
	$Label.text = "Current Infections: " + str((float(current_infections) / float(total_population) * 100)) + "%"
	
	var new_bar = bar_scene.instance()
	new_bar.rect_size = Vector2(rect_size.x, (rect_size.y/total_population)*current_infections)
	add_child(new_bar)
	
	var bars = get_tree().get_nodes_in_group("bar")
	for i in range(bars.size()):
		var bar = bars[i]
		var new_width = rect_size.x/bars.size()
		bar.rect_size = Vector2(new_width/2, bar.rect_size.y)
		bar.rect_position = Vector2(new_width*i + (new_width/4), rect_size.y - bar.rect_size.y)
	
