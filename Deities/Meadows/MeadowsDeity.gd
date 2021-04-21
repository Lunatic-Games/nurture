extends Node2D

var APPEARANCE_MULTIPLIER = 1
var MIN_APPEARANCE_TIME = 3
var MAX_APPEARANCE_TIME = 6


onready var appearance_timer = $AppearanceTimer
onready var offering_timer = $OfferingTimer

onready var destination_flag = get_tree().get_nodes_in_group('deity_flag')[0]
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
	var destination = destination_flag.global_position + get_spawn_offset()
	
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
func get_spawn_offset():
	return Vector2(rng.randf_range(-64, 64), rng.randf_range(-64, 64))


# Enable displaying ui
func _on_VisibilityNotifier2D_screen_entered():
	pass # Replace with function body.


# Disable displaying ui
func _on_VisibilityNotifier2D_screen_exited():
	pass # Replace with function body.
