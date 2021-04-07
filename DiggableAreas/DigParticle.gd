extends Node2D

onready var particle_manager = get_node("Particles2D")

func _ready():
	global_position = get_global_mouse_position()
	particle_manager.one_shot = true
	particle_manager.emitting = true

func _process(_delta):
	if (! particle_manager.emitting):
		queue_free()
