extends Node2D


onready var goals
onready var next_level

onready var goal_card = preload("res://goal_controller/goal_card.tscn")
onready var half_spacer = preload("res://goal_controller/half_spacer.tscn")
onready var spacer = preload("res://goal_controller/spacer.tscn")
onready var menu = load("res://menus/main_menu/main_menu.tscn")

onready var popup = get_node("Popup")
onready var goal_container = get_node("Popup/GoalContainer")
onready var popup_animator = get_node("Popup/AnimationPlayer")

onready var is_collapsed = true
onready var goal_tally = []


func _process(_delta):
	if (Input.is_action_just_pressed("dev_button")):
		game_over()


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		# bring in the box
		if is_collapsed:
			popup_goals()
		else:
			collapse_goals()


func populate_goals():
	
	
	var count = 0
	var spaced = false
	
	for goal in goals:
		var card
		
		count += 1
		# If populating the final row
		if (! spaced && count + 2 >= goals.size()):
			spaced = true
			# determine if spacer card needs dropped
			if (goals.size()%3 >= 2):
				# Two cards exist, final row needs a half spacer
				card = half_spacer.instance()
				goal_container.add_child(card)
				
			elif (goals.size()%3 >= 1):
				# One card exists, final row needs a spacer
				card = spacer.instance()
				goal_container.add_child(card)
		
		card = goal_card.instance()
		card.get_node("Button/Sprite").texture = goal[0]
		card.get_node("Button/RichTextLabel").text = "x" + String(goal[1])
		goal_container.add_child(card)
		goal_tally.append(0)


func popup_goals():
	if (is_collapsed):
		popup_animator.play("pop_in")
		is_collapsed = false

func collapse_goals():
	if (! is_collapsed):
		popup_animator.play("collapse")
		is_collapsed = true


func _on_HideGoals_pressed():
	collapse_goals()


func check_for_goal(plant):
	var count = 0
	for goal in goals:
		if (goal[0] == plant.plant_sprite):
			goal_tally[count] += 1

			
			if (goal_tally[count] >= goal[1]):
				get_tree().call_group("goal_card", "completed_goal", goal[0])
				goals.remove(goals.find(goal))
				goal_tally.remove(count)
				break
	print(goal_tally)
	if (goals.size() == 0):
		game_over()


func game_over():
	popup.get_node("HideGoals").visible = false
	popup.get_node("Menu").visible = true
	popup.get_node("NextLevel").visible = true
	popup_goals()


func _on_Menu_pressed():
	get_tree().paused = false
	var _scene = get_tree().change_scene_to(menu)


func _on_NextLevel_pressed():
	get_tree().paused = false
	var _scene = get_tree().change_scene_to(next_level)
