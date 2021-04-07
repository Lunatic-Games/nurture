extends Node2D

onready var play_size = 3
onready var loaded_plot = preload('res://Plots/BasicPlot.tscn')
onready var loaded_player = preload('res://PlayerController/PlayerController.tscn')
onready var plot
onready var x_offset = loaded_plot.instance().get_node("PlotSprite").texture.get_size()[0]
onready var y_offset = loaded_plot.instance().get_node("PlotSprite").texture.get_size()[1]

# Used to lock the camera to the map
onready var top_bound
onready var bottom_bound
onready var left_bound
onready var right_bound

func _ready():
	for y in range(play_size):
		for x in range(play_size):
			plot = loaded_plot.instance()
			plot.get_node("PlotSprite")
			add_child(plot)
			plot.position += Vector2(x_offset + x*x_offset, y_offset + y*y_offset)
