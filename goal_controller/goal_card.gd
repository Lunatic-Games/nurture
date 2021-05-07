extends Control

func completed_goal(sprite):
	if (get_node("Button/Sprite").texture == sprite):
		get_node("ColorRect").visible = true
