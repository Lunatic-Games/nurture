extends Button

onready var open = false
onready var animator = get_parent().get_node("BackpackAnimator")


func _on_Backpack_pressed():
	if (animator.is_playing()):
		return
	
	if (! open):
		open = true
		animator.play("Open")
	else:
		open = false
		animator.play("Close")
