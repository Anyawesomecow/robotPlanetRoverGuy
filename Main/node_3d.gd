extends Node3D

func _input(event):
	if event.is_action_pressed("esc"):
		if event.is_action_pressed("esc"):
			if $in_game_menue.paused:
				$in_game_menue.close()
			else:
				$in_game_menue.open()
