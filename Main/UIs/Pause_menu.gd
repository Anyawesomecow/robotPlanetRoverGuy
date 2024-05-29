extends Control

var Is_Paused = false

func pause():
	print("gorp")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	Is_Paused = true
	
func Play():
	print("goim")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	Is_Paused = false
	
func _input(event):
	if event.is_action_pressed("esc"):
		if Is_Paused == false:
			pause()
		else:
			Play()
