extends Node2D


export (Array) var level_goals
export (PackedScene) var next_level
export (Array, Resource) var starting_seeds

onready var goal_controller = get_node("GoalControllerLayer/GoalController")
onready var inventory = get_tree().get_nodes_in_group("player_inventory")[0]

func _ready():
	goal_controller.goals = level_goals
	goal_controller.next_level = next_level
	
	for seedling in starting_seeds:
		inventory.gain_seed(seedling)
	
	# Show the goals for the level
	goal_controller.populate_goals()
	goal_controller.popup_goals()
