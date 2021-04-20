extends Node2D

export (Resource) var fissle
export (float) var chance_for_fissle

onready var adj_plots
onready var current_plant
onready var is_plant_grown
onready var is_plant_on_cooldown = true
onready var times_harvested = 0
onready var times_nurtured = 0
onready var days_grown = 0
onready var rng = RandomNumberGenerator.new()

onready var animation = get_node("AnimationPlayer")
onready var idle_anim = get_node("PlantSprite/Idling")
onready var plant_sprite = get_node("PlantSprite")
onready var plant_downtimer = get_node("PlantDowntime")
onready var player_controller = get_tree().get_nodes_in_group('player')[0]
onready var player_inventory = get_tree().get_nodes_in_group('player_inventory')[0]
onready var happy_noise = get_node("HappyNoise")
onready var angry_noise = get_node("AngryNoise")
onready var love_emitter = get_node("LoveParticle")
onready var angry_emitter = get_node("AngryParticle")
onready var water_emitter = get_node("WaterParticle")
onready var hover_text = get_node("HoverText")

onready var seed_drop = preload("res://Drops/SeedDrops/SeedDrop.tscn")

signal gain_coins


func _on_Area2D_mouse_entered():
	# Grow the plot a tiny amount
	if (! "focused" in animation.get_queue()):
		animation.queue("focused")


func _on_Area2D_mouse_exited():
	# Return the plot to normal size
	if (! "unfocused" in animation.get_queue()):
		animation.queue("unfocused")



func sow(plant_seed):
	
	# Reset the plot so it's ready
	empty_plot()
	current_plant = plant_seed
	plant_downtimer.start(current_plant.downtime)
	idle_anim.play("idle")
	
	# Show the plant
	display_plant()
	enable_tooltip()



func display_plant():
	if (is_plant_grown):
		plant_sprite.texture = current_plant.plant_sprite
	else:
		plant_sprite.texture = current_plant.seed_sprite



func new_day():
	
	# if a plant is planted
	if (current_plant):
		
		# If the plant is grown, do it's effect
		if (is_plant_grown):
			plant_day_effect()
		else:
			# Otherwise, grow the plant
			age_seedling()
	
	
	# No plant has been planted
	else:
		# Try and spawn a fissle
		rng.randomize()
		if (rng.randf() <= chance_for_fissle):
			sow(fissle)



func plant_day_effect():
	pass



func age_seedling():
	days_grown += 1
	
	if (days_grown >= current_plant.growing_time):
		plant_aged()


func plant_aged():
	idle_anim.stop(true)
	is_plant_grown = true
	plant_downtimer.start(current_plant.downtime)
	get_tree().call_group("goal_controller", "check_for_goal", current_plant)
	display_plant()
	enable_tooltip()
	
	# get the multiplier and calculate score
	var multiplier = 1
	if (times_nurtured >= current_plant.nurture_threshold):
		multiplier = current_plant.nurture_multiplier
	get_tree().call_group("goal_controller", "increase_score", current_plant.score, multiplier)
	
	# Check for seed drops
	drop_seeds()

func drop_seeds():
	rng.randomize()
	var drops_count
	
	# Give the player a random amount of base seeds
	if (current_plant.drops_seed):
		drops_count = rng.randi_range(1, current_plant.max_own_seeds_dropped)
		for seedling in drops_count:
			player_inventory.gain_seed(current_plant)
			drop_seed(current_plant)
	
	# Give the player a chance for other seeds, if the plant has any
	if (current_plant.other_drops.size() > 0 && rng.randf() <= current_plant.others_drop_chance):
		drops_count = rng.randi_range(1, current_plant.max_others_dropped)
		for seedling in drops_count:
			var drop = current_plant.other_drops[rng.randi_range(0,current_plant.other_drops.size()-1)]
			player_inventory.gain_seed(drop)
	
	if (times_nurtured >= current_plant.nurture_threshold && current_plant.rare_drops.size() > 0 && rng.randf() <= current_plant.rare_seed_drop_chance):
		var x = 0
		while x < current_plant.rare_seeds_dropped_if_nurtured:
			current_plant.rare_drops.shuffle()
			player_inventory.gain_seed(current_plant.rare_drops[0])
			x += 1



func enable_tooltip():
	
	hover_text.get_node("RichTextLabel").rect_position.y = -32
	hover_text.get_node("RichTextLabel").rect_position.x = -50
	
	if (is_plant_grown):
		hover_text.get_node("RichTextLabel").rect_position.y = -40
	
	hover_text.get_node("RichTextLabel").bbcode_text = "[center]" + current_plant.plant_name + "[/center]"
	hover_text.visible = true




func _on_Area2D_input_event(_viewport, event, _shape_idx):
	
	# If the plot is clicked
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		if (current_plant):
			
			# If the plant is not on cooldown
			if (! is_plant_on_cooldown):
				plant_is_happy()
			else:
				plant_is_upset()



func plant_is_upset():
	is_plant_on_cooldown = true
	plant_downtimer.start(current_plant.downtime)
	plant_sprite.get_node("AnimationPlayer").play("growing")
	# ANGRY PARTICLE
	angry_emitter.emitting = true
	# Play an angry noise
	if (! angry_noise.playing):
		angry_noise.play()


func plant_is_happy():
	is_plant_on_cooldown = true
	plant_downtimer.start(current_plant.downtime)
	plant_sprite.get_node("AnimationPlayer").play("growing")
	love_emitter.emitting = true
	
	# if the plant is grown, harvest it
	if (is_plant_grown):
		harvest_plant()
	# If the plant is not grown, nurture it
	else:
		nurture_plant()
	
	# Playing a happy noise
	if (! happy_noise.playing):
		happy_noise.play()


func plant_is_resting():
	is_plant_on_cooldown = true
	plant_downtimer.start(current_plant.downtime)
	plant_sprite.get_node("AnimationPlayer").play("growing")
	# Play a happy noise
	if (! happy_noise.playing):
		happy_noise.play()

func harvest_plant():
	times_harvested += 1
	
	# give the player a seed (chance to)
	drop_own_seed()
	# Make te plant rest, indicate to player
	plant_is_resting()
	
	# After harvest is done, remove the plant
	if (times_harvested >= current_plant.clicks_to_harvest):
		gain_coins()
		player_inventory.gain_plant(current_plant)
		empty_plot()

func nurture_plant():
	times_nurtured += 1


func gain_coins():
	# Caught by the money manager
	emit_signal("gain_coins", current_plant.gold_dropped)


func empty_plot():
	current_plant = null
	days_grown = 0
	is_plant_grown = false
	is_plant_on_cooldown = true
	times_harvested = 0
	times_nurtured = 0
	plant_sprite.texture = null
	plant_downtimer.stop()
	hover_text.visible = false


func drop_own_seed():
	rng.randomize()
	# Check to add the plant as a seed of itself
	if (current_plant.drops_seed && rng.randf() <= current_plant.seed_drop_chance):
		player_inventory.gain_seed(current_plant)
		drop_seed(current_plant)


func drop_seed(current_plant):
	var seedling = seed_drop.instance()
	get_tree().get_root().add_child(seedling)
	seedling.global_position = self.global_position
	seedling.initialize(current_plant)


func _on_PlantDowntime_timeout():
	plant_sprite.get_node("AnimationPlayer").play("growing")
	# WATER PARTICLE
	water_emitter.emitting = true
	plant_downtimer.start(current_plant.downtime)
	is_plant_on_cooldown = false
