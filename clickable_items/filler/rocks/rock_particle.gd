extends Node2D

func _ready():
	$Particles2D.emitting = true

func _process(_delta):
	if (! $Particles2D.emitting):
		queue_free()
