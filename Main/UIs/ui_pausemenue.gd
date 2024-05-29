extends Control

func open():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	get_tree().Paused = true


func UnPause():
	$".".hide()
	get_tree().Paused = false

func _input(event):
	if event.is_action_pressed("esc"):
		UnPause()
