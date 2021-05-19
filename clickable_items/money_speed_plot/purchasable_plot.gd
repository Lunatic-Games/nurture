extends Node2D

onready var event_manager = $EventManager


func _on_Area2D_input_event(viewport, event, shape_idx):
	
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		event_manager.generate_events()
