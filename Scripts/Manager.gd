extends Node

@onready var pause_menu = $"../Pause/PauseMenu"
var game_paused: bool = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		game_paused = !game_paused

	if game_paused:
		get_tree().paused = game_paused
		pause_menu.show()
	else:
		get_tree().paused = game_paused
		pause_menu.hide()


func _on_resume_pressed():
	game_paused = !game_paused


func _on_exit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu_1.tscn")


func _on_exit_the_game_pressed():
	get_tree().quit()
