extends VideoPlayer


onready var menu = preload("res://TestScene/Menu.tscn")

func _on_VideoPlayer_finished():
	get_tree().change_scene_to(menu)
