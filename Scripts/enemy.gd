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
var damage = 20
var health = 20

var hero
var direction

@onready var animation = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var attack_direction = $AttackDirection

func _ready():
	Signals.connect("hero_position_update", Callable(self, "_on_hero_position_update"))
	Signals.connect("hero_attack", Callable(self, "_on_damage_received"))

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
	animation.play("Idle")
	state = CHASE

func attack_state():
	animation.play("Attack")
	await animation.animation_finished	
	state = RECOVER

func chase_state():
	direction = (hero - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		attack_direction.scale = Vector2(-1,1)
	else:
		sprite.flip_h = false
		attack_direction.scale = Vector2(1,1)

func damage_state():
	state = IDLE
	await animation.animation_finished

func death_state():
	animation.play("Death")
	await animation.animation_finished
	queue_free()

func recover_state():
	animation.play("Recover")
	await animation.animation_finished
	state = IDLE

func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)

func _on_damage_received(hero_damage):
	health -= hero_damage
	if health <= 0:
		state = DEATH
	else:
		state = IDLE
		state = DAMAGE
