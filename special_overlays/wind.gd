extends Line2D

export (float, 200, 2000) var speed = 500.0
export (float, 0, 100) var amplitude = 25
export (float, 0, 0.05) var period_multipler = 0.007
 
export (int) var length = 200
export (int) var n_points = 10

var front_position = 0.0
var bound = INF  # Can be used to wrap around

onready var segment_length = length / n_points


func _ready():
	clear_points()
	for _i in n_points:
		add_point(Vector2())


func _physics_process(delta):
	front_position += delta * speed
	front_position = fmod(front_position, bound)
	
	for i in n_points:
		var x = front_position + i * segment_length
		var y = amplitude * sin(x * period_multipler)
		set_point_position(i, Vector2(x, y))


func jump_forward(amount):
	front_position = amount
