extends Control

onready var seedling = preload("res://plants/tutorial_cablit.tres")

onready var tutorial_plot = get_parent().get_parent().get_node("TutorialPlotStarter")
onready var basic_plot = get_parent().get_parent().get_node("BasicPlot")
onready var goal_controller = get_parent().get_parent().get_node("CanvasLayer").get_node("GoalController")
onready var player_controller = get_parent().get_parent().get_node("PlayerController")

onready var tut_message_1 = get_node("Tut_1")
onready var tut_message_2 = get_node("Tut_2")
onready var tut_message_3 = get_node("Tut_3")
onready var tut_message_4 = get_node("Tut_4")
onready var tut_message_5 = get_node("Tut_5")
onready var tut_message_6 = get_node("Tut_6")
onready var tut_message_7 = get_node("Tut_7")

onready var alt_message_1 = get_node("Alt_1")

onready var nurtured_a_seed = false
onready var planted_a_seed = false
onready var grown_a_plant = false
onready var harvested_a_plant = false
onready var opened_goals = false
onready var failed_nurturing = false

func _ready():
	tutorial_plot.connect("seed_sown", self, "seed_planted")
	tutorial_plot.connect("seed_nurtured", self, "seed_nurtured")
	tutorial_plot.connect("plant_grown", self, "plant_grown")
	tutorial_plot.connect("plant_harvested", self, "plant_harvested")
	goal_controller.connect("popup_goals_pressed", self, "goals_shown")
	goal_controller.connect("goals_completed", self, "goals_completed")
	
	# HIDE GOAL CARDS FROM THE PLAYER

func seed_planted():
	if (! planted_a_seed):
		tut_message_1.visible = false
		tut_message_2.visible = true
		planted_a_seed = true

func seed_nurtured():
	if (! nurtured_a_seed):
		if (!failed_nurturing):
			tut_message_2.visible = false
		else:
			alt_message_1.visible = false
		
		tut_message_3.visible = true
		nurtured_a_seed = true

func plant_grown():
	if (! grown_a_plant):
		if (nurtured_a_seed):
			tut_message_3.visible = false
			tut_message_4.visible = true
			grown_a_plant = true
		else:
			# RESET THE PLOT
			failed_nurturing = true
			tutorial_plot.empty_plot()
			tutorial_plot.sow(seedling)
			tut_message_2.visible = false
			alt_message_1.visible = true

func plant_harvested():
	if (! harvested_a_plant):
		tut_message_4.visible = false
		tut_message_5.visible = true
		goal_controller.visible = true
		harvested_a_plant = true

func goals_shown():
	if (! opened_goals):
		tut_message_5.visible = false
		tut_message_6.visible = true
		basic_plot.visible = true
		player_controller.gain_seed(seedling)
		player_controller.gain_seed(seedling)
		opened_goals = true

func goals_completed():
	tut_message_6.visible = false
	tut_message_7.visible = true

