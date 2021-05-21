extends Control

onready var tween = $Tween
onready var start_position


var data

signal chosen


func _on_Card_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		emit_signal("chosen", data)


func _on_Card_mouse_entered():
	
	# Save the cards original location
	if start_position:
		rect_position = start_position
	else:
		start_position = rect_position
	
	tween.interpolate_property(self, "rect_position",
		rect_position, rect_position + Vector2(0, -9), 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	tween.interpolate_property(self, "rect_position",
	rect_position, start_position, 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	tween.interpolate_property(self, "rect_position",
	rect_position, rect_position + Vector2(0, -4.5), 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	yield(tween, "tween_completed")
	tween.interpolate_property(self, "rect_position",
	rect_position, start_position, 0.1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
