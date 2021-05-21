extends Node

var expansion = preload("res://expansions/herb.tscn")

func trigger_event(event):
	
	var invisible_wall = get_parent().get_parent()
	var current_expansion = invisible_wall.get_parent()
	
	var new_expansion = expansion.instance()
	new_expansion.position = current_expansion.position + Vector2(-1727.6345, 0)
	current_expansion.get_parent().add_child(new_expansion)
	invisible_wall.queue_free()
