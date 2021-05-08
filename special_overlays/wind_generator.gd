extends Node2D


const wind_scene = preload("res://special_overlays/wind.tscn")

export (Vector2) var extents
export (float) var height_gap = 100.0
export (float) var left_margin = 200.0
export (float) var right_margin = 400.0

func _ready():
	randomize()
	for h in range(-extents.y, extents.y + height_gap, height_gap):
		var wind = wind_scene.instance()
		wind.bound = extents.x * 2 + right_margin
		add_child(wind)
		wind.position = Vector2(-extents.x - left_margin, h)
		wind.jump_forward(rand_range(0, extents.x * 2.0 + right_margin + left_margin))
