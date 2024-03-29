extends Node2D


@onready var slides = $AnimatedSprite2D
var counter = 0

func _ready():
	pass

func _process(delta):
	slides.frame = counter


func _on_button_pressed():
	counter += 1
	if counter == 7:
		get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")
		counter = 0
