extends Timer

onready var day_bar = get_parent()

func _on_MomentTimer_timeout():
	if (day_bar.value < day_bar.max_value):
		day_bar.value += 1
	else:
		day_bar.value = 0
		get_tree().call_group('new_day', 'new_day')


func _on_DevDayButton_pressed():
	day_bar.value = 99
