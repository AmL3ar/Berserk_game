extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var stamina_bar = $Stamina

var stamina_cost
var attack_cost = 30

var stamina = 100
var max_health = 300
var health:
	set(value):
		health = value
		health_bar.value = health

func _ready():
	health = max_health
	health_bar.max_value = health
	health_bar.value = health

func _process(delta):
	stamina_bar.value = stamina
	if stamina < 100:
		stamina += 8 * delta

func stamina_consumption():
	stamina -= stamina_cost
