extends Node2D

export (Resource) var plant
onready var collision_shape = get_node("Area2D/CollisionShape2D")


func move_plant():
	global_position = get_global_mouse_position()
