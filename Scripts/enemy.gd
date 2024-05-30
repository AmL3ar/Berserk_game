extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = 0: 
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()
				

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var damage = 30
var health = 20
var speed = 150

var hero = Vector2.ZERO
var direction = Vector2.ZERO
var player_dmg = 0

@onready var animation = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var attack_direction = $AttackDirection

func _ready():
	Signals.connect("hero_position_update", Callable(self, "_on_hero_position_update"))
	Signals.connect("hero_attack", Callable(self, "_on_damage_received"))
	state = CHASE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if state == CHASE:
		chase_state()
	move_and_slide()

func _on_hero_position_update(hero_pos):
	hero = hero_pos	

func _on_attack_range_body_entered(body):
	state = ATTACK
	
func idle_state():
	velocity.x = 0
	animation.play("Idle")
	state = CHASE

func attack_state():
	velocity.x = 0
	animation.play("Attack")
	await animation.animation_finished
	state = RECOVER

func chase_state():
	animation.play("Run")
	direction = (hero - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		attack_direction.scale = Vector2(-1,1)
	else:
		sprite.flip_h = false
		attack_direction.scale = Vector2(1,1)
	velocity.x = direction.x * speed

func damage_state():
	velocity.x = 0
	state = IDLE
	await animation.animation_finished

func death_state():
	velocity.x = 0
	animation.play("Death")
	await animation.animation_finished
	queue_free()

func recover_state():
	velocity.x = 0
	animation.play("Recover")
	await animation.animation_finished
	state = IDLE

func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)

func _on_damage_received(hero_damage):
	player_dmg = hero_damage


func _on_hurt_box_area_entered(area):
	await get_tree().create_timer(0.1).timeout
	health -= player_dmg
	if health <= 0:
		state = DEATH
	else:
		state = IDLE
		state = DAMAGE

func _on_run_timeout():
	speed = move_toward(speed, randi_range(120, 170), 100)
