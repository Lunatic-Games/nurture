extends Node2D

# Event manager base variables
export (bool) var has_choice = false
export (int) var choices = 0
# Event pools and rarity of being pulled
export (Array, Resource) var common_events
export (float) var common_chance = 0.9
export (Array, Resource) var uncommon_events
export (float) var uncommon_chance = 0.1


var rng = RandomNumberGenerator.new()


onready var color_rect = $CanvasLayer/ColorRect
onready var card_display = $CanvasLayer/HBoxContainer
onready var card_template = preload("res://event_handling/event_card/event_card.tscn")


###########################################
# Generates events for the user to choose,
# Or randomly selects one based on vars.
###########################################
func generate_events():
	
	if has_choice:
		
		# Cap the choices to 3
		if choices > 3:
			choices = 3
		
		var events = pull_events(choices)
		
		color_rect.visible = true
		for event in events:
			generate_card(event)
		
	else:
		
		var event = pull_event()
		trigger_event(event)


###############################################
# Chooses one event at random based on rarity
###############################################
func pull_event():
	rng.randomize()
	var chance = rng.randf()
	
	# Check common event
	if (chance <= common_chance):
		return common_events[rng.randi() % common_events.size()]
	
	# Check uncommon event
	chance -= common_chance
	if (chance <= uncommon_chance):
		return uncommon_events[rng.randi() % uncommon_events.size()]


###############################################
# Chooses multiple events at random based on rarity
###############################################
func pull_events(number):
	
	var free_common_events = common_events.duplicate()
	var free_uncommon_events = uncommon_events.duplicate()
	
	var events = []
	
	# If the events are all meant to be shown, just get them in order
	if (free_common_events.size() == number && common_chance >= 1):
		for event in free_common_events:
			events.push_back(event)
		
	else:
		# Get the events in a random order
		for index in number:
			print("Index: ", index)
			print("Common: ", free_common_events)
			rng.randomize()
			var chance = rng.randf()
			var selected = false
			
			# Check common event
			if (!selected && chance <= common_chance):
				var random_int = rng.randi()
				events.push_back(free_common_events[random_int % free_common_events.size()])
				free_common_events.remove(random_int  % free_common_events.size())
				selected = true
				
			# Check uncommon event
			chance -= common_chance
			if (!selected && chance <= uncommon_chance):
				var random_int = rng.randi()
				events.push_back(free_uncommon_events[random_int % free_uncommon_events.size()])
				free_uncommon_events.remove(random_int  % free_uncommon_events.size())
				selected = true
	
	return events



###########################################
# Triggers the passed event, using the
# attached script of the resouce.
# The attached script is loaded onto a
# node2d instance and then freed
###########################################
func trigger_event(event):
	
	# If the choice ui is open, close it
	if has_choice:
		color_rect.visible = false
		Util.remove_children(card_display)
	
	# Generate Node2D
	var node = Node2D.new()
	node.set_script(event.event_script)
	add_child(node)
	
	# Use node to handle event
	node.trigger_event(event)
	node.queue_free()



###########################################
# Generates and fills out a card
###########################################
func generate_card(data):
	
	var card = card_template.instance()
	card.get_node("Title").text = data.display_name
	card.get_node("Description").text = data.display_description
	card.get_node("Sprite").texture = data.display_image
	card.data = data
	card_display.add_child(card)
	
	card.connect("chosen", self, "trigger_event")
