extends CanvasLayer

@onready var health_bar = $HealthBar

var max_health = 700
var health:
	set(value):
		health = value
		health_bar.value = health

func _ready():
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
