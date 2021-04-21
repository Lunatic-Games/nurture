extends Node2D

var APPEARANCE_MULTIPLIER = 1
var MIN_APPEARANCE_TIME = 3
var MAX_APPEARANCE_TIME = 6


onready var appearance_timer = $AppearanceTimer
onready var offering_timer = $OfferingTimer

onready var destination_box = get_tree().get_nodes_in_group('deity_box')[0]
onready var rng = RandomNumberGenerator.new()



func _ready():
	# Randomize the seed
	rng.randomize()
	
	# Set the inital time until the deity appears
	var appearance_time = rng.randf_range(3, 6)
	appearance_timer.start(appearance_time)


# Moves the deity into the world space
func enter_world_space():
	
	# Select the destination
	var destination = get_random_position_in_box(destination_box)
	
	# Move to the destination
	global_position = destination
	
	# Upon reaching the destination
	# Wait a few moments
	display_offering_ui()



# Display the ui for the offering to be made
func display_offering_ui():
	pass



# The deity should appear with another request
func _on_AppearanceTimer_timeout():
	enter_world_space()


# Returns a random position within the box
func get_random_position_in_box(box):
	var box_sprite = box.get_node("Sprite")
	var box_pos = box.global_position
	var box_size = box_sprite.texture.get_size() * box_sprite.scale
	print(box_size)
	
	var chosen_position = box_pos + Vector2(rng.randf_range(-box_size.x, box_size.x), rng.randf_range(-box_size.y, box_size.y))
	return chosen_position
