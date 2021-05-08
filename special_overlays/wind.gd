extends Line2D

export (float) var speed = 200.0

export (int) var n_points
export (float) var segment_length

onready var path_length = $Path.curve.get_baked_length()
onready var path_position = path_length

func _ready():
	for _i in n_points:
		add_point(Vector2())

func _physics_process(delta):
	path_position -= speed * delta
	for i in n_points:
		set_point_position(i, $Path.curve.interpolate_baked(path_position + i * segment_length))
	
