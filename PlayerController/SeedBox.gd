extends NinePatchRect

func cast_ray(space_state):
	# Check if ui is castable
	var result = space_state.intersect_ray(get_global_mouse_position(), get_global_mouse_position()+Vector2(0.1, 0.1), [], 1, false, true)
	print(result)
