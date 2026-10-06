extends Control

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		visible = true

func _on_continue_button_pressed() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/levels.tscn")

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_node(get_tree().get_root())
