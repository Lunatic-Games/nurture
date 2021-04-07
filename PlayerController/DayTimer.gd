extends Timer

export (Color) var day_color = Color("#d9e74b") # bright yellow
export (Color) var night_color = Color("#400c39") # deep purple
export (Curve) var color_ratio

onready var color_rect = get_node("DayOverlay")

# Mixes the day and night color using the ratio curve and the day timer
func _physics_process(_delta):
	var t = (wait_time - time_left) / wait_time
	color_rect.color = lerp(night_color, day_color, color_ratio.interpolate(t))


func _on_DayTimer_timeout():
	get_tree().call_group('new_day', 'new_day')
