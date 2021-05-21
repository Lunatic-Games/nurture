extends Node


func _process(delta):
	
	if (Input.is_action_just_pressed("dev_gain_coins")):
		get_tree().call_group("money_manager", "gain_coins", 5)

