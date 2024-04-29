extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE
}

var state: int = 0: 
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
				

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var damage = 20

var hero
var direction

@onready var animation = $AnimationPlayer
@onready var collision = $AttackDirection/AttackRange/CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var attack_direction = $AttackDirection

func _ready():
	Signals.connect("hero_position_update", Callable(self, "_on_hero_position_update"))

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
	await get_tree().create_timer(1).timeout
	collision.disabled = false
	state = CHASE

func attack_state():
	animation.play("Attack")
	await animation.animation_finished
	collision.disabled = true	
	state = IDLE

func chase_state():
	direction = (hero - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		attack_direction.rotation_degrees = 180
	else:
		sprite.flip_h = false
		attack_direction.rotation_degrees = 0

func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)
