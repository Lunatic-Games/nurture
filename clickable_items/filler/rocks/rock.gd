extends Node2D


onready var rock_particle = preload("res://clickable_items/filler/rocks/rock_particle.tscn")



func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		
		# Create the particle
		var particle = rock_particle.instance()
		add_child(particle)
		
		# Shake the rock
		$Shake.play("shake")
