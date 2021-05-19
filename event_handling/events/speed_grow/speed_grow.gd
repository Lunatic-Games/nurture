extends Node

var plot = preload("res://plots/speed_grow/speed_grow.tscn")

func trigger_event(event):
	
	var current_plot = get_parent().get_parent()
	
	var new_plot = plot.instance()
	new_plot.global_position = current_plot.global_position
	current_plot.get_parent().add_child(new_plot)
	current_plot.queue_free()
