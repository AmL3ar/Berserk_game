extends Node2D

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("Menu") 


func _process(delta):
	if animation.is_playing() == false:
		get_tree().change_scene_to_file("res://Scenes/Story.tscn")


func _on_start_pressed():
	animation.play("StartMenu")
	$Button_Exit.hide()
	$Logo.hide()
	$Button_Start.hide()
	$Volume.hide()

func _on_exit_pressed():
	get_tree().quit()
