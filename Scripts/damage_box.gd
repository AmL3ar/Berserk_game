extends Node2D

@onready var collision = $HitBox/CollisionShape2D

func _ready():
	collision.disabled = true
