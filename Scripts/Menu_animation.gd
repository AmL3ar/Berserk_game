extends Node2D

@onready var animation = $AnimatedSprite2D
@onready var audio = $Music_settings

func _ready():
	animation.play("Menu")	
   


func _process(delta):
	update_volume(-audio.value)
	if animation.is_playing() == false:
		get_tree().change_scene_to_file("res://Scenes/Story.tscn")


func _on_start_pressed():
	animation.play("StartMenu")
	$Button_Exit.visible = false
	$Logo.visible = false
	$Button_Start.visible = false
	

func _on_exit_pressed():
	get_tree().quit()
	
	
func update_volume(vol):
	AudioServer.set_bus_volume_db(0, vol)
