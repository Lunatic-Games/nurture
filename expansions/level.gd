extends Node2D


export (Array) var level_goals
export (PackedScene) var next_level
export (Array, Resource) var starting_seeds


onready var inventory = get_tree().get_nodes_in_group("player_inventory")[0]

func _ready():

	for seedling in starting_seeds:
		inventory.gain_seed(seedling)
