extends Node2D

export (Vector2) var starting_position
export (float) var starting_offset
export (Vector2) var speed

var rng = RandomNumberGenerator.new()

func _ready():
	start_cloud()


func _physics_process(delta):
	position += speed
	
	if position.x > AutoVars.world_limit:
		start_cloud()


func start_cloud():
	var offset = Vector2(0, rng.randf_range(-starting_offset, starting_offset))
	position = starting_position + offset
