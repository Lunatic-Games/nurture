extends StaticBody2D


onready var animator = $AnimationPlayer

func _on_TextureButton_mouse_entered():
	animator.play("selected")
