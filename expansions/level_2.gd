extends Node2D


export (Array) var level_goals
export (PackedScene) var next_level
onready var goal_controller = get_node("CanvasLayer").get_node("GoalController")

func _ready():
	goal_controller.goals = level_goals
	goal_controller.next_level = next_level
	
	# Show the goals for the level
	goal_controller.populate_goals()
	goal_controller.popup_goals()
