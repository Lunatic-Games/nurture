extends Node2D

export (float) var scale_x = 1
export (float) var scale_y = 1
export (int) var PRICE = 1
export (float) var DISPLAY_HEIGHT = 0


onready var tween = $Tween
onready var fade_tween = $FadeTween
onready var display = $Display
onready var display_price = $Display/HBoxContainer/DisplayedPrice
onready var collision_shape = $HoverChecker/CollisionShape2D


var start_position
var popup_animation = false


func _ready():
	collision_shape.scale = Vector2(scale_x, scale_y)
	display_price.text = String(PRICE)



# Display the price
func _on_HoverChecker_mouse_entered():
	display_price()


# Hide the price
func _on_HoverChecker_mouse_exited():
	hide_price()



func display_price():
	
	# Save the display original location
	if start_position == null:
		start_position = position
		display.visible = true
	else:
		position = start_position
	
	tween.interpolate_property(display, "position",
		position, position + Vector2(0, DISPLAY_HEIGHT), 0.24,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	
	fade_tween.interpolate_property(display, "modulate",
		Color(1,1,1,0), Color(1,1,1,1), 0.18,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
	
	popup_animation = true
	
	yield(tween, "tween_all_completed")
	popup_animation = false
	

func hide_price():
	
#	tween.interpolate_property(display, "position",
#		position, start_position, 0.14,
#		Tween.TRANS_LINEAR, Tween.EASE_IN)
#	tween.start()
	if (popup_animation):
		yield(tween, "tween_all_completed")
	
	
	fade_tween.interpolate_property(display, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 0.12,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
