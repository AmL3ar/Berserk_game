extends Node2D

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("Menu")	
   


func _process(delta):
	if animation.is_playing() == false:
		get_tree().change_scene_to_file("res://Scenes/Story.tscn")


func _on_start_pressed():
	animation.play("StartMenu")
	$Start.visible = false
	$Exit.visible = false
	$Stroka.visible = false
	

func _on_exit_pressed():
	get_tree().quit()


