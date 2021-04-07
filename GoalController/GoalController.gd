extends Node2D

export (int) var SCORE_INCREASE_RATE = 1000

onready var goals
onready var next_level

onready var goal_card = preload("res://GoalController/GoalCard.tscn")
onready var half_spacer = preload("res://GoalController/HalfSpacer.tscn")
onready var spacer = preload("res://GoalController/Spacer.tscn")
onready var menu = load("res://TestScene/Menu.tscn")
onready var popup_grid = get_node("Popup/PopupGrid/GridContainer")
onready var popup_animator = get_node("Popup/AnimationPlayer")
onready var score_audio = get_node("ScoreAudio")
onready var is_collapsed = true
onready var goal_tally = []
onready var score = 0
onready var goal_score = 0


func _process(delta):
	if score < goal_score:
		score = min(score + int(SCORE_INCREASE_RATE * delta), goal_score)
		get_node("Score").text = "SCORE: " + String(score)
		score_audio.playing = true
	elif score > goal_score:
		score = max(score - int(SCORE_INCREASE_RATE * delta), goal_score)
		get_node("Score").text = "SCORE: " + String(score)
		score_audio.playing = true
	else:
		score_audio.playing = false
	
	if (Input.is_action_just_pressed("dev_button")):
		game_over()



func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		# bring in the box
		popup_goals()

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
				popup_grid.add_child(card)
				
			elif (goals.size()%3 >= 1):
				# One card exists, final row needs a spacer
				card = spacer.instance()
				popup_grid.add_child(card)
		
		card = goal_card.instance()
		card.get_node("Button/Sprite").texture = goal[0]
		card.get_node("Button/RichTextLabel").text = "x" + String(goal[1])
		popup_grid.add_child(card)
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


func increase_score(plant_score, multiplier):
	goal_score += plant_score*multiplier

func game_over():
	popup_grid.get_parent().get_node("HideGoals").visible = false
	popup_grid.get_parent().get_node("Menu").visible = true
	popup_grid.get_parent().get_node("NextLevel").visible = true
	popup_goals()


func _on_Menu_pressed():
	get_tree().paused = false
	var _scene = get_tree().change_scene_to(menu)


func _on_NextLevel_pressed():
	get_tree().paused = false
	var _scene = get_tree().change_scene_to(next_level)
