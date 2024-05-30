extends Control


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")



func _on_exit_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu_1.tscn")
