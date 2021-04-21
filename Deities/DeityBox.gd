extends Node2D

onready var sprite = $Sprite

# returns true size of sprite
func get_true_size():
	return sprite.texture.get_size() * sprite.scale
