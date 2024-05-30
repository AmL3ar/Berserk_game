extends Node2D

@onready var hero = $Hero
@onready var timer = $Mobs/Spawner

var tree_preload = preload("res://Scenes/enemy.tscn")

func _on_spawner_timeout():
	tree_spawn()

func tree_spawn():
	var tree = tree_preload.instantiate()
	tree.position = Vector2(randi_range(3725, 4325), 495)
	$Mobs.add_child(tree)


func _on_area_spawn_body_entered(body):
	if body == hero:
		timer.start()
