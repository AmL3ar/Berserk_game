extends Node2D

@onready var hero = owner.get_parent().find_child("Hero")
@export var mini_root_node : PackedScene
@onready var timer = $Timer

func _ready():
	timer.stop()

func _on_timer_timeout():
	spawn()

func spawn():
	var mini_root = mini_root_node.instantiate()
	mini_root.position.x = hero.position.x - 50
	mini_root.position.y = 490
	get_tree().current_scene.call_deferred("add_child", mini_root)


func _on_hero_detection_body_entered(body):
	if body == hero:
		timer.start()
