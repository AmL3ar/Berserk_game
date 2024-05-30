extends CharacterBody2D

var damage = 50

func _on_body_entered(body):
	body._on_damage_received(damage)
