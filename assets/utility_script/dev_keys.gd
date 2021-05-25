extends Node


func _process(delta):
	
	if (Input.is_action_just_pressed("dev_gain_coins")):
		get_tree().call_group("money_manager", "gain_coins", 5)

	if (Input.is_action_just_pressed("dev_pass_day")):
		var timer = get_tree().get_nodes_in_group("day_timer")[0]
		timer.start(0.1)
	
	if (Input.is_action_just_pressed("dev_grow_plants")):
		get_tree().call_group("plot", "grow_plant")
