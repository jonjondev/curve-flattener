extends ColorRect

var current_infections = 0
var total_population = 0
onready var infections_label = get_tree().root.get_node("Node2D/Stats/Label")


func report_new_infection():
	current_infections = get_tree().get_nodes_in_group("infected").size()
	total_population = get_tree().get_nodes_in_group("node").size()
	update_display()

func update_display():
	infections_label.text = "Current Infections: " + str((float(current_infections) / float(total_population) * 100)) + "%"
