extends Node2D

export (Curve) var seed_ratio
export (float) var travel_time = 1.75

onready var option_1 = $Option1
onready var backpack = get_tree().get_nodes_in_group("backpack")[0]
onready var camera = get_tree().get_nodes_in_group("camera")[0]


var t = 0.0
func _process(delta):
	assert (backpack)
	
	t += delta / travel_time
	
	var topLeft = camera.get_camera_screen_center() - camera.get_viewport_rect().size / 2  
	option_1.points[option_1.points.size() - 1] = topLeft + backpack.rect_position + backpack.rect_size / 2
	var anim_position = multi_interpolate(option_1, seed_ratio.interpolate(t))
	
	global_position = anim_position
	
	if t > 1:
		queue_free()


func initialize(seedling):
	$Sprite.texture = seedling.seed_sprite
	
	var point_count = option_1.get_point_count()
	
	# Convert option 1 into global space
	for index in range(point_count):
		option_1.points[index] = global_position + option_1.points[index]


# Time is already lerp'd with ratio
func multi_interpolate(line, time):
	var point_count = line.get_point_count()
	
	if (point_count <= 2):
		var curr_point = line.get_point_position(0)
		var next_point = line.get_point_position(1)
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
