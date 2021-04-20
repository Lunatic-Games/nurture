extends Node2D

export (Resource) var plant
onready var collision_shape = get_node("Area2D/CollisionShape2D")


func sow(plot):
	# If the plant can be planted
	if (! plot.current_plant):
		plot.sow(self.plant)
		queue_free()


func move_seed():
	global_position = get_global_mouse_position()
