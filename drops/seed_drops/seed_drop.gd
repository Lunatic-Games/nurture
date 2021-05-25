extends Node2D

export (Curve) var seed_ratio
export (float) var travel_time = 0.42
export (float) var anticipation_time = 0.4
export (float) var hover_time = 0.8
export (Vector2) var min_offset = Vector2(-30, -40)
export (Vector2) var max_offset = Vector2(30, -60)


onready var option_1 = $Option1
onready var tween = $Tween
onready var backpack = get_tree().get_nodes_in_group("backpack")[0]
onready var camera = get_tree().get_nodes_in_group("camera")[0]

var rng = RandomNumberGenerator.new()
var anticipation_complete = false


var t = 0.0
func _process(delta):
	assert (backpack)
	
	# If the anticipation has been completed
	if (anticipation_complete):
		t += delta / travel_time
		
		var topLeft = camera.get_camera_screen_center() - camera.get_viewport_rect().size / 2  
		option_1.points[option_1.points.size() - 1] = topLeft + backpack.rect_position + backpack.rect_size / 2
		var anim_position = multi_interpolate(option_1, seed_ratio.interpolate(t))
		
		global_position = anim_position
		
		if t > 1:
			queue_free()


func initialize(seedling):
	
	$Sprite.texture = seedling.seed_sprite
	
	anticipate_tween()
	
	# Wait for the anticipation tween to finish
	yield(tween, "tween_all_completed")
	
	yield(get_tree().create_timer(hover_time), "timeout")
	
	var point_count = option_1.get_point_count()
	
	# Convert option 1 into global space
	for index in range(point_count):
		option_1.points[index] = global_position + option_1.points[index]
	
	anticipation_complete = true


# Time is already lerp'd with ratio
func multi_interpolate(line, time):
	var point_count = line.get_point_count()
	
	if (point_count <= 2):
		var curr_point = line.get_point_position(0)
		var _next_point = line.get_point_position(1)
		return curr_point.linear_interpolate
	
	# iterate through all but the last point
	var new_line = []
	
	for index in range(point_count-1):
		var curr_point = line.get_point_position(index)
		var next_point = line.get_point_position(index + 1)
		var pos = curr_point.linear_interpolate(next_point, time)
		new_line.append(pos)
		
	
	return multi_interpolate_rec(new_line, time)


# Time is already lerp'd with ratio
func multi_interpolate_rec(line, time):
	var point_count = line.size()
	
	if (point_count <= 2):
		var curr_point = line[0]
		var next_point = line[1]
		return curr_point.linear_interpolate(next_point, time)
	
	# iterate through all but the last point
	var new_line = []
	
	for index in range(point_count-1):
		var curr_point = line[index]
		var next_point = line[index + 1]
		var pos = curr_point.linear_interpolate(next_point, time)
		new_line.append(pos)
		
	
	return multi_interpolate_rec(new_line, time)


func anticipate_tween():
	
	# Generate a random offset to tween to
	rng.randomize()
	
	var offset = Vector2(rng.randf_range(min_offset.x, max_offset.x), rng.randf_range(min_offset.y, max_offset.y))
	tween.interpolate_property(
		self, "position",
		position, position + offset,
		anticipation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
