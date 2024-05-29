extends Control

var Is_Paused = true

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


func _on_play_pressed():
	Play()


func _on_options_pressed():
	pass # Replace with function body.


func _on_main_menue_pressed():
	get_tree().change_scene_to_file("res://UIs/menues/main menue.gd")
