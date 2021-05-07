extends Control
onready var SLIDER_MAX_VAL = 100
onready var menu = load("res://TestScene/Menu.tscn")
onready var pressed_audio = get_node("Pressed")
onready var music_slider = get_node("VBoxContainer/MusicSlider")
onready var sound_slider = get_node("VBoxContainer/SoundsSlider")
onready var fullscreen_check = get_node("VBoxContainer/Fullscreen")
onready var menu_slide_animator = get_node("Panel/MenuSlideIn")

func _ready():
	# Set the sliders to the correct position
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var value = db2linear(db)
	music_slider.value = value*SLIDER_MAX_VAL
	
	db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))
	value = db2linear(db)
	sound_slider.value = value*SLIDER_MAX_VAL
	
	# Set fullscreen to the correct state
	fullscreen_check.pressed = OS.window_fullscreen
	
	menu_slide_animator.play("SlideFromRight")

func _on_MusicSlider_value_changed(value):
	var db = linear2db(value/SLIDER_MAX_VAL)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)


func _on_SoundsSlider_value_changed(value):
	var db = linear2db(value/SLIDER_MAX_VAL)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), db)


func _on_SoundsSlider_gui_input(event):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && !pressed_audio.playing):
		pressed_audio.play()

func _on_Back_pressed():
	var _scene = get_tree().change_scene_to(menu)


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
