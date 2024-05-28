extends Control

func Pause():
	get_tree().Paused = true
	$".".show()
func UnPause():
	$".".hide()
	get_tree().Paused = false

func _input(event):
	if event.is_action_pressed("esc"):
		UnPause()
