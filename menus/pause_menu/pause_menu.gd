extends Control

onready var paused = false
onready var SLIDER_MAX_VAL = 100

onready var pause_menu = get_node("PausedButtons")
onready var options_menu = get_node("OptionsSettings")
onready var audio_player = get_node("OptionsSettings/SoundsSettings/SoundPlayer")

onready var menu_scene = load("res://menus/main_menu/main_menu.tscn")

func _ready():
	var music_slider = $OptionsSettings/MusicSettings/MusicSlider
	var sound_slider = $OptionsSettings/SoundsSettings/SoundsSlider
	
	# Set the sliders to the correct position
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var value = db2linear(db)
	music_slider.value = value*SLIDER_MAX_VAL
	
	db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))
	value = db2linear(db)
	sound_slider.value = value*SLIDER_MAX_VAL


func _process(_delta):
	if (Input.is_action_just_pressed("pause")):
		toggle()
		set_pause_state()
		set_menu_state()


func toggle():
	if (paused):
		paused = false
	else:
		paused = true


func set_pause_state():
	get_tree().paused = paused


func set_menu_state():
	if (paused):
		visible = true
		pause_menu.visible = true
	else:
		options_menu.visible = false
		visible = false


func _on_Options_pressed():
	pause_menu.visible = false
	options_menu.visible = true


func _on_Menu_pressed():
	toggle()
	set_pause_state()
	var _scene = get_tree().change_scene_to(menu_scene)


func _on_Resume_pressed():
	toggle()
	set_pause_state()
	set_menu_state()

# FROM OPTIONS
func _on_Back_pressed():
	pause_menu.visible = true
	options_menu.visible = false


func _on_MusicSlider_value_changed(value):
	var db = linear2db(value/SLIDER_MAX_VAL)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)


func _on_SoundsSlider_value_changed(value):
	var db = linear2db(value/SLIDER_MAX_VAL)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), db)
	audio_player.play(0.0)
