extends ColorRect

var bar_scene = preload("res://scenes/bar.tscn")

var total_population = 0
var current_infections = 0
var current_immune = 0

var current_day = 0

var peak_infection_rate = 0
var total_uninfected

func _ready():
	$Timer.connect("timeout", self, "update_stats")

func update_stats():
	current_day += 1
	current_infections = get_tree().get_nodes_in_group("infected").size()
	current_immune = get_tree().get_nodes_in_group("immune").size()
	total_population = get_tree().get_nodes_in_group("node").size()
	
	var infection_rate = stepify((float(current_infections) / float(total_population) * 100), 0.01)
	if infection_rate > peak_infection_rate:
		peak_infection_rate = infection_rate
	
	$"../Info/DaysLabel".text = "Days Passed: " + str(current_day)
	$"../Info/InfectionsLabel".text = "Current Infections: " + str(infection_rate) + "%"
	
	var new_infections_bar = bar_scene.instance()
	new_infections_bar.rect_size = Vector2(rect_size.x, (rect_size.y/total_population)*current_infections)
	new_infections_bar.color = Color(1, 0, 0)
	new_infections_bar.add_to_group("infection_bar")
	add_child(new_infections_bar)
	
	var new_immunity_bar = bar_scene.instance()
	new_immunity_bar.rect_size = Vector2(rect_size.x, (rect_size.y/total_population)*current_immune)
	new_immunity_bar.color = Color(0, 1, 0)
	new_immunity_bar.add_to_group("immune_bar")
	add_child(new_immunity_bar)
	
	var bars = get_tree().get_nodes_in_group("infection_bar")
	for i in range(bars.size()):
		var bar = bars[i]
		var new_width = rect_size.x/bars.size()
		bar.rect_size = Vector2(new_width/2, bar.rect_size.y)
		bar.rect_position = Vector2(new_width*i + (new_width/4), rect_size.y - bar.rect_size.y)
	
	bars = get_tree().get_nodes_in_group("immune_bar")
	for i in range(bars.size()):
		var bar = bars[i]
		var new_width = rect_size.x/bars.size()
		bar.rect_size = Vector2(new_width/2, bar.rect_size.y)
		bar.rect_position = Vector2(new_width*i + (new_width/4), 0)
	
	if current_infections <= 0:
		total_uninfected = stepify((float(total_population - current_immune) / float(total_population) * 100), 0.01)
		SceneManager.end_game(get_parent())
		$Timer.stop()
