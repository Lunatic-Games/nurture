extends Node2D

# Preloads
onready var base_seed = preload("res://PlantSeeds/BaseSeed.tscn")
onready var test_seed = preload("res://Plants/cablit.tres")
onready var dig_particle = preload("res://DiggableAreas/DigParticle.tscn")

# Nodes
onready var seed_box = get_node("CanvasLayer/SeedBox")
onready var camera = get_node("Camera2D")
onready var animator = get_node("ScreenShake")

# World bound vars
onready var world_bounds_center = Vector2(0,0)# Vector2(OS.window_size[0] / 2, OS.window_size[1] / 2)
onready var world_bounds_min = world_bounds_center + Vector2(-600, -400)
onready var world_bounds_max = world_bounds_center + Vector2(600, 400)

onready var CAMERA_SPEED = 250
onready var SEED_SIZE = 32
onready var seed_dig_chance = 0.01
onready var rng = RandomNumberGenerator.new()

onready var held_seed



func _physics_process(delta):
	
	# Used to perform raycasts
	var space_state = get_world_2d().direct_space_state
	
	# Moves the camera based on player input
	move_camera_by_input(delta)
	
	# Handle seed movement
	if (held_seed):
		held_seed.move_seed()
	
	# Handle mouse input
	handle_mouse_input(space_state)



func _ready():
	position = world_bounds_center
	#gain_seed(test_seed)

func handle_mouse_input(space_state):
	if (Input.is_action_just_released("select")):
		
		# Handle seed movement
		if (held_seed):
			
			# Check to see if the seed is within the seed box rect
			if (is_seed_in_seed_box()):
				# Move the seed to the new position
				held_seed.seed_box_pos = held_seed.position
		
			# If the seed is released outside of the seedbox
			else:
				
				# Raycast for a plot, try and plant if able
				attempt_seed_sowing(space_state)
			
			# Move the seed to the seedbox
			held_seed.position = held_seed.seed_box_pos
		else:
			attempt_dig_for_seed(space_state)
		
		# After all is done, release the seed
		held_seed = null

func move_camera_by_input(delta):
	var direction = Vector2(0,0)
	
	if (Input.is_action_pressed("down")):
		direction += Vector2(0, CAMERA_SPEED)
	
	if (Input.is_action_pressed("up")):
		direction += Vector2(0, -CAMERA_SPEED)
	
	if (Input.is_action_pressed("left")):
		direction += Vector2(-CAMERA_SPEED, 0)
	
	if (Input.is_action_pressed("right")):
		direction += Vector2(CAMERA_SPEED, 0)
	
	direction.normalized()
	
	# Move the controller, if it is in bounds
	if (in_bounds(direction)):
		position += delta*direction



func in_bounds(direction):
	var temp_pos = position
	temp_pos += direction
	
	# if the new position is in bounds
	if (temp_pos[0] <= world_bounds_max[0] && temp_pos[0] >= world_bounds_min[1] && temp_pos[1] <= world_bounds_max[1] && temp_pos[1] >= world_bounds_min[1]):
		return true
	return false



func gain_seed(plant_seed):
	
	# Calculate the area to add the seed to
	var rect_size = seed_box.rect_size
	#var rect_position = seed_box.rect_position
	
	rng.randomize()
	var x_pos = rng.randi_range(SEED_SIZE, rect_size[0] - SEED_SIZE)
	var y_pos = rng.randi_range(SEED_SIZE, rect_size[1] - SEED_SIZE)
	var seedling = base_seed.instance()
	seedling.plant = plant_seed
	seed_box.add_child(seedling)
	seedling.get_node("Sprite").texture = seedling.plant.seed_sprite
	seedling.position = Vector2(x_pos, y_pos)



func is_seed_in_seed_box():
	var seedbox_size = held_seed.seedbox_parent.rect_size
	
	if (held_seed.position[0] < seedbox_size[0] && held_seed.position[0] >= 0 && held_seed.position[1] < seedbox_size[1] && held_seed.position[1] >= 0):
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



func attempt_dig_for_seed(space_state):
	var result = space_state.intersect_ray(get_global_mouse_position(), get_global_mouse_position()+Vector2(0.1,0.1), [], 4, false, true)
	
	if (result.has("collider")):
		
		create_dig_particle()
			
		rng.randomize()
		if (rng.randf() <= seed_dig_chance):
			gain_seed(test_seed)
		
		shake_screen()



func create_dig_particle():
	var node = dig_particle.instance()
	get_parent().add_child(node)

func shake_screen():
	if (! animator.is_playing()):
		animator.play("minishake")
