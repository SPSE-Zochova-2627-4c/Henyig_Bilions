extends Node3D


func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()
