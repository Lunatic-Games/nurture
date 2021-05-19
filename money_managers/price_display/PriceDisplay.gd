extends Node2D

export (int) var price = 1


onready var tween = $Tween
onready var fade_tween = $FadeTween
onready var display = $Display
onready var display_price = $Display/DisplayedPrice


var start_position


func _ready():
	set_price()

func set_price():
	display_price.text = String(price)


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
		position, position + Vector2(0, -18), 0.24,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	
	fade_tween.interpolate_property(display, "modulate",
		Color(1,1,1,0), Color(1,1,1,1), 0.18,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()

func hide_price():
	
	tween.interpolate_property(display, "position",
		position, start_position, 0.12,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	fade_tween.interpolate_property(display, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
