extends CanvasLayer

func _on_exit_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu_1.tscn")


func _on_exit_the_game_pressed():
	get_tree().quit()
