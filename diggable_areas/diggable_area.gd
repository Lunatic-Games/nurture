extends Node2D

var dirt_particle = preload("res://diggable_areas/dig_particle.tscn")



func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		var particle = dirt_particle.instance()
		get_tree().get_root().add_child(particle)
		particle.global_position = get_global_mouse_position()
		particle.scale = Vector2(1,1)
