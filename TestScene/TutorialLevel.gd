extends Node2D


export (Array) var level_goals
export (PackedScene) var next_level
export (Array, Resource) var starting_seeds

onready var goal_controller = get_node("CanvasLayer").get_node("GoalController")
onready var player = get_node("PlayerController")

func _ready():
	goal_controller.goals = level_goals
	goal_controller.next_level = next_level
	
	for seedling in starting_seeds:
		player.gain_seed(seedling)
	
	# Show the goals for the level
	goal_controller.populate_goals()
	goal_controller.collapse_goals()
	goal_controller.visible = false
