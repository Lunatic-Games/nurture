extends Control

onready var options = preload("res://TestScene/Options.tscn")
onready var level_1 = preload("res://TestScene/Level1.tscn")
onready var tutorial = preload("res://TestScene/Tutorial.tscn")


func _on_Play_pressed():
	var _scene = get_tree().change_scene_to(level_1)


func _on_Options_pressed():
	var _scene = get_tree().change_scene_to(options)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Tutorial_pressed():
	var _scene = get_tree().change_scene_to(tutorial)
