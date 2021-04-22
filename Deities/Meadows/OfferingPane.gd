extends Sprite


export (Array, Resource) var offerings
export (Array, Resource) var rewards

onready var offerings_completed = 0
onready var player_inventory = get_tree().get_nodes_in_group('player_inventory')[0]


func _ready():
	set_current_offering()


# TODO Add offering resource and use it instead of plant resource
func set_current_offering():
	$Offering.texture = offerings[offerings_completed].plant_sprite


func handle_plant(offering):
	
	print("HANDLING OFFERING")
	
	# The offering is correct
	if is_plant_offering(offering):
		offerings_completed += 1
		print("Completed offering")
		
		# Play acknowledging sound (Bell chiming??)
		
		# Drop a reward if applicable
		
		set_current_offering()
	
	# Offering was not correct
	else:
		print("Offering was wrong")
		
		# Play grunt sound
		
		# Add item back to player inventory
		player_inventory.gain_plant(offering)



# Returns true if the offering is correct
func is_plant_offering(offering):
	if (offering == offerings[offerings_completed]):
		return true
	return false
