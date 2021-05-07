extends RichTextLabel


func _physics_process(delta):
	rect_position = get_global_mouse_position() 
