extends Node2D

export (Resource) var plant
onready var collision_shape = get_node("Area2D/CollisionShape2D")

var is_held = false
var seed_box_pos
onready var plantable_plots = []
onready var seedbox_parent = get_parent()
onready var player_controller = get_parent().get_parent().get_parent()


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if (event.pressed):
			if (! player_controller.held_seed):
				raise()
				seed_box_pos = position
				is_held = true
				player_controller.held_seed = self
			
		else:
			# When the seed is released
			is_held = false

func sow(plot):
	# If the plant can be planted
	if (! plot.current_plant):
		plot.sow(self.plant)
		queue_free()


func move_seed():
	position = get_global_mouse_position() - seedbox_parent.rect_position
