extends Node2D

var type_map = {
	"plant" : preload("res://plants/herbs/rosemary.tres")
}


onready var player_inventory = get_tree().get_nodes_in_group('player_inventory')[0]


func handle_plant(plant):
	grind_plant(plant)


func grind_plant(plant):
	
	if (plant.plant_type != "herb"):
		get_seed_from_type(plant.plant_type)


func get_seed_from_type(type):
	var resource = type_map[type]
	player_inventory.gain_seed(resource)
	
