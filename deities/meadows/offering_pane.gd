extends Sprite


onready var offerings = get_parent().offerings
onready var rewards = get_parent().rewards
onready var offerings_completed = 0
onready var player_inventory = get_tree().get_nodes_in_group('player_inventory')[0]


func _ready():
	set_current_offering()


# TODO Add offering resource and use it instead of plant resource
func set_current_offering():
	if (offerings_completed < offerings.size()):
		$Offering.texture = offerings[offerings_completed].plant_sprite
	else:
		print("Appeased the deity")



func handle_plant(offering):
	
	# The offering is correct
	if is_plant_offering(offering):
		complete_offering(offering)
		set_current_offering()
	
	# Offering was not correct
	else:
		
		# Play grunt sound
		
		# Add item back to player inventory
		player_inventory.gain_plant(offering)



# Handles completion of an offering
func complete_offering(offering):
		offerings_completed += 1
		print("Completed offering")
		
		# Play acknowledging sound (Bell chiming??)
		
		# Drop a reward if applicable
		if (offerings.size() > offerings_completed && offerings[offerings_completed]):
			var reward = offerings[offerings_completed]
			player_inventory.gain_seed(reward)
		
		# Hide the offering panel
		get_parent().hide_offering_panel()
		# Wait for 1.5 seconds
		yield(get_tree().create_timer(1.5), "timeout")
		# Leave the world space
		get_parent().leave_world_space()



# Returns true if the offering is correct
func is_plant_offering(offering):
	if (offering == offerings[offerings_completed]):
		return true
	return false
