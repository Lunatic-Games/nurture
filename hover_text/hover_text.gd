extends Node2D

export (float) var DELAY_TIME = 1

onready var hover_delay = get_node("HoverDelay")
onready var text = get_node("RichTextLabel")

onready var text_display_height = -64

func _on_Area2D_mouse_entered():
	if (hover_delay.is_stopped()):
		hover_delay.start(DELAY_TIME)


func _on_Area2D_mouse_exited():
	hover_delay.stop()
	text.visible = false

func _on_HoverDelay_timeout():
	text.visible = true
