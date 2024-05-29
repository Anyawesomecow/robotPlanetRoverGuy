extends Node3D

func _input(event):
	if event.is_action_pressed("esc") and :
		$in_game_menue.open()
