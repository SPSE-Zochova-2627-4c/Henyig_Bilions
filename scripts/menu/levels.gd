extends Control


func _on_lvl_0_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/map_1.tscn")



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
