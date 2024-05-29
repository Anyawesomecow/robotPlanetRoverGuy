extends Control
var paused = false

func open():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$".".show()
	get_tree().paused = true
	paused = true


func close():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$".".hide()
	get_tree().paused = false
	paused = false
	
func _input(event):
	print("blorguse")
	if event.is_action_pressed("esc"):
		if paused:
			close()
		else:
			open()
