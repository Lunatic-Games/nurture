extends Node

var plot = preload("res://plots/money_grow/money_grow.tscn")

func trigger_event(event):
	
	var current_plot = get_parent().get_parent()
	
	var new_plot = plot.instance()
	new_plot.position = current_plot.position
	current_plot.get_parent().add_child(new_plot)
	current_plot.queue_free()
