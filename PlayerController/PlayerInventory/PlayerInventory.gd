extends Control

onready var inventory = {}
onready var inventory_container = $ScrollContainer/InventoryList
export (Array, Resource) var seeds

onready var inventory_card = preload("res://PlayerController/PlayerInventory/InventoryCard.tscn")
onready var base_seed = preload("res://PlantSeeds/BaseSeed.tscn")
onready var base_plant = preload("res://HarvestedPlants/BasePlant.tscn")

onready var player_controller = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	if (false):
		for seedling in seeds:
			gain_seed(seedling)


func gain_seed(plant):
	
	if (plant.seed_sprite in inventory):
		inventory[plant.seed_sprite][0] += 1
		
		for index in inventory_container.get_item_count():
			if inventory_container.get_item_icon(index) == plant.seed_sprite:
				var temp_string = "x" + str(inventory[plant.seed_sprite][0])
				inventory_container.set_item_text(index, temp_string)
	else:
		inventory[plant.seed_sprite] = [1, plant, "seed"]
		var text = "x1"
		inventory_container.add_item(text, plant.seed_sprite, true)



func gain_plant(plant):
	
	if (plant.plant_sprite in inventory):
		inventory[plant.plant_sprite][0] += 1
		
		for index in inventory_container.get_item_count():
			if inventory_container.get_item_icon(index) == plant.plant_sprite:
				var temp_string = "x" + str(inventory[plant.plant_sprite][0])
				inventory_container.set_item_text(index, temp_string)
	else:
		inventory[plant.plant_sprite] = [1, plant, "plant"]
		var text = "x1"
		inventory_container.add_item(text, plant.plant_sprite, true)


func _on_InventoryList_item_selected(index):
	#TODO: Player now holds a seed --> if they let go then they drop it
	
	# Get the corresponding icon
	var icon = inventory_container.get_item_icon(index)
	
	if (inventory[icon][2] == "seed"):
		instance_seed_from_icon(icon)
	elif (inventory[icon][2] == "plant"):
		instance_plant_from_icon(icon)
	
	# Decrease the number of seeds in reserve
	inventory[icon][0] -= 1
	inventory_container.set_item_text(index, "x"+ str(inventory[icon][0]))
	if (inventory[icon][0] <= 0):
		inventory_container.remove_item(index)
		inventory.erase(icon)
		



func instance_seed_from_icon(icon):
	
	# Get the correct plant resource
	var plant_data = inventory[icon][1]
	
	# Instance the base seed
	var seedling = base_seed.instance()
	seedling.plant = plant_data
	get_tree().get_root().add_child(seedling)
	seedling.get_node("Sprite").texture = seedling.plant.seed_sprite
	player_controller.held_seed = seedling


func instance_plant_from_icon(icon):
	
	# Get the correct plant resource
	var plant_data = inventory[icon][1]
	
	# Instance the base seed
	var plant_instance = base_plant.instance()
	plant_instance.plant = plant_data
	get_tree().get_root().add_child(plant_instance)
	plant_instance.get_node("Sprite").texture = plant_instance.plant.plant_sprite
	player_controller.held_plant = plant_instance
