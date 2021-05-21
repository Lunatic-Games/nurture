extends KinematicBody2D

const CAMERA_SPEED = 25
const SEED_SIZE = 32

# Preloads
onready var base_seed = preload("res://plant_seeds/base_seed.tscn")
onready var test_seed = preload("res://plants/cablit.tres")
onready var dig_particle = preload("res://diggable_areas/dig_particle.tscn")

# Nodes
onready var camera = get_node("Camera2D")
onready var animator = get_node("ScreenShake")
onready var inventory = get_node("PlayerInventoryOverlay/PlayerInventory")

# World bound vars
onready var world_bounds_center = Vector2(0,0)# Vector2(OS.window_size[0] / 2, OS.window_size[1] / 2)
onready var world_bounds_min = world_bounds_center + Vector2(-600, -400)
onready var world_bounds_max = world_bounds_center + Vector2(600, 400)


onready var seed_dig_chance = 0.01
onready var rng = RandomNumberGenerator.new()

onready var held_seed
onready var held_plant


func _physics_process(delta):
	

	# Used to perform raycasts
	var space_state = get_world_2d().direct_space_state
	
	# Moves the camera based on player input
	move_camera_by_input(delta)
	
	# Handle seed movement
	if (held_seed):
		held_seed.move_seed()
	
	# Handle plant movement
	if (held_plant):
		held_plant.move_plant()
	
	# Handle mouse input
	handle_mouse_input(space_state)



func _ready():
	position = world_bounds_center
	#gain_seed(test_seed)


func handle_mouse_input(space_state):
	if (Input.is_action_just_released("select")):
		
		# Handle seed movement
		if (held_seed):
			# Raycast for a plot, try and plant if able
			var sown_seed = attempt_seed_sowing(space_state)
			
			# If the seed was not sowed, add it back to inventory
			if (! sown_seed):
				inventory.gain_seed(held_seed.plant)
			
			# After all is done, release the seed
			held_seed.queue_free()
			held_seed = null
		elif (held_plant):
			
			var action = attempt_plant_action(space_state)
			
			# If no action was taken, add the plant to inventory
			if (! action):
				inventory.gain_plant(held_plant.plant)
			
			# After all is done, return plant
			held_plant.queue_free()
			held_plant = null
		else:
			
			# Not holding a seed
			#attempt_dig_for_seed(space_state)
			pass

func move_camera_by_input(_delta):
	var direction = Vector2(0,0)
	
	if (Input.is_action_pressed("down")):
		direction += Vector2(0, CAMERA_SPEED)
	
	if (Input.is_action_pressed("up")):
		direction += Vector2(0, -CAMERA_SPEED)
	
	if (Input.is_action_pressed("left")):
		direction += Vector2(-CAMERA_SPEED, 0)
	
	if (Input.is_action_pressed("right")):
		direction += Vector2(CAMERA_SPEED, 0)
	
	var val = move_and_collide(direction)
	
	#direction.normalized()
	
	# Move the controller, if it is in bounds
	#if (in_bounds(direction)):
	#	position += delta*direction



func in_bounds(direction):
	var temp_pos = position
	temp_pos += direction
	
	# if the new position is in bounds
	if (temp_pos[0] <= world_bounds_max[0] && temp_pos[0] >= world_bounds_min[1] && temp_pos[1] <= world_bounds_max[1] && temp_pos[1] >= world_bounds_min[1]):
		return true
	return false



func attempt_seed_sowing(space_state):
	var result = space_state.intersect_ray(get_global_mouse_position(), get_global_mouse_position()+Vector2(0.1, 0.1), [], 2, false, true)
	
	# Set the plot as the intersected node
	var plot
	if (result.has("collider")):
		plot = result["collider"].get_parent()
		
		# If the plot has no plant, plant the seed
		if (held_seed && plot.current_plant == null):
			held_seed.sow(plot)
			return true
	return false


func attempt_plant_action(space_state):
	var result = space_state.intersect_ray(get_global_mouse_position(), get_global_mouse_position()+Vector2(0.1, 0.1), [], 1, false, true)
	print(result)
	
	# Set the plot as the intersected node
	var node
	if (result.has("collider")):
		node = result["collider"].get_parent()
		print(node)
		
		if (node.is_in_group("plant_actionable")):
			node.handle_plant(held_plant.plant)
			return true
	
	return false



func attempt_dig_for_seed(space_state):
	var result = space_state.intersect_ray(get_global_mouse_position(), get_global_mouse_position()+Vector2(0.1,0.1), [], 4, false, true)
	
	if (result.has("collider")):
		
		create_dig_particle()
			
		rng.randomize()
		if (rng.randf() <= seed_dig_chance):
			inventory.gain_seed(test_seed)
		
		shake_screen()



func create_dig_particle():
	var node = dig_particle.instance()
	get_parent().add_child(node)

func shake_screen():
	if (! animator.is_playing()):
		animator.play("minishake")
