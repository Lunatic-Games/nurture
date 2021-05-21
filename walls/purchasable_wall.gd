extends StaticBody2D


onready var animator = $AnimationPlayer
onready var price_display = $PriceDisplay
onready var event_manager = $EventManager


func _on_HoverChecker_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		
		if (AutoVars.current_coins >= price_display.PRICE):
			event_manager.generate_events()
			get_tree().call_group("money_manager", "lose_coins", price_display.PRICE)
