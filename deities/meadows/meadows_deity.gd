extends Node2D


export (Array, Resource) var offerings
export (Array, Resource) var rewards


var TIME_MULTIPLIER = 1
var MIN_APPEARANCE_TIME = 5
var MAX_APPEARANCE_TIME = 8
var MIN_OFFERING_TIME = 1
var MAX_OFFERING_TIME = 2


onready var offerings_completed = 0
onready var appearance_timer = $AppearanceTimer
onready var offering_timer = $OfferingTimer
onready var offering_pane = $OfferingPane
onready var tween = $Tween
onready var stag_animator = $StagAnimator
onready var display_offering = false
onready var in_world = false

onready var destination_flag = get_tree().get_nodes_in_group('deity_flag')[0]
onready var home_flag = get_tree().get_nodes_in_group('deity_home')[0]
onready var player_inventory = get_tree().get_nodes_in_group('player_inventory')[0]
onready var rng = RandomNumberGenerator.new()



func _ready():
	# Randomize the seed
	rng.randomize()
	
	# Set the inital time until the deity appears
	var appearance_time = rng.randf_range(MIN_APPEARANCE_TIME, MAX_APPEARANCE_TIME)
	appearance_timer.start(appearance_time * TIME_MULTIPLIER)
	
	offering_pane.set_current_offering()


# Moves the deity into the world space
func enter_world_space():
	in_world = true
	
	# Select the destination
	var destination = destination_flag.global_position + get_spawn_offset()
	
	# Move to the destination
	tween.interpolate_property(self, "position",
		global_position, destination, 5)
	tween.start()
	
	# Start the animation
	stag_animator.play("walk")
	$Sprite.flip_h = false
	


# Moves the deity into the world space
func leave_world_space():
	
	in_world = false
	# Select the destination
	var destination = home_flag.global_position + get_spawn_offset()
	
	# Move to the destination
	tween = get_node("Tween")
	tween.interpolate_property(self, "position",
		global_position, destination, 5)
	tween.start()
	
	# Start the animation
	stag_animator.play("walk")
	$Sprite.flip_h = true



# Display the ui for the offering to be made
func display_offering_ui():
	display_offering = true
	$OfferingPane.visible = true
	
	# start the offering timer
	var offering_time = rng.randf_range(MIN_OFFERING_TIME, MAX_OFFERING_TIME)
	offering_timer.start(offering_time * TIME_MULTIPLIER)



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


# No offer was given in time, leave
func _on_OfferingTimer_timeout():
	
	# Offering failed
	display_offering = false
	$OfferingPane.visible = false
	
	# Leave
	leave_world_space()



# Deity arrived at destination
func _on_Tween_tween_completed(_object, _key):
	
	if (in_world):
		stag_animator.play("r_idle")
		# Wait 0.5 seconds, then resume execution.
		yield(get_tree().create_timer(0.5), "timeout")
		stag_animator.play("look")
		# Wait 2 seconds, then resume execution.	
		yield(get_tree().create_timer(2.0), "timeout")
		display_offering_ui()
		# Wait 6 seconds, then resume execution.
		yield(get_tree().create_timer(6.0), "timeout")
		stag_animator.play("ear_flick")
	else:
		
		# Set the time until the deity appears again
		var appearance_time = rng.randf_range(MIN_APPEARANCE_TIME, MAX_APPEARANCE_TIME)
		appearance_timer.start(appearance_time * TIME_MULTIPLIER)
