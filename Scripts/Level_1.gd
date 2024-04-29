extends Node2D

@onready var healthBar = $CanvasLayer/HealthBar
@onready var hero = $Hero

func _ready():
	healthBar.max_value = hero.max_health
	healthBar.value = healthBar.max_value

func _on_hero_health_changed(new_health):
	healthBar.value = new_health
