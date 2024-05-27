extends CharacterBody2D

signal health_changed(new_health)

enum {
	MOVE,
	EASYATTACK,
	DAMAGE,
	DEATH
}

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimationPlayer
@onready var rotate = $AttackDirection
@onready var hitbox = $AttackDirection/DamageBox/HitBox
var max_health = 100
var curr_dir = "IdleRight"
var state = MOVE
var damage_basic = 50

var hero_pos
var health

func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health

func _physics_process(delta):
	match state:
		MOVE:
			move_state()		
		EASYATTACK:
			attack_state()
		DAMAGE:
			damage_state()
		DEATH:
			death_state()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if curr_dir == "IdleRight":
			if velocity.y < 300:
				animation.play("JumpRightUp")
			else:
				animation.play("JumpRightDown")
		else:
			if velocity.y < 300:
				animation.play("JumpLeftUp")
			else:
				animation.play("JumpLeftDown")
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY			
	
	move_and_slide()
	
	hero_pos = self.position
	Signals.emit_signal("hero_position_update", hero_pos)

func move_state():
	var direction = Input.get_axis("ui_left","ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		if velocity.x > 0 and velocity.y == 0:
			animation.play("RunRight")
			rotate.rotation_degrees = 0
			rotate.position.x = 0
			rotate.position.y = 0
			hitbox.position.y = 0
			curr_dir = "IdleRight"
		elif velocity.y == 0:
			animation.play("RunRight")
			rotate.rotation_degrees = 180
			rotate.position.x = -45
			rotate.position.y = 13
			hitbox.position.y = -15
			curr_dir = "IdleLeft"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play(curr_dir)
	
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		state = EASYATTACK

func attack_state():
	velocity.x = 0
	if curr_dir == "IdleRight":
		animation.play("EasyAttackRight")
		await animation.animation_finished
	else:
		animation.play("EasyAttackLeft")
		await animation.animation_finished
	state = MOVE

func damage_state():
	velocity.x = 0
	if curr_dir == "IdleRight":
		animation.play("DamageRight")
		await animation.animation_finished
	else:
		animation.play("DamageLeft")
		await animation.animation_finished
	state = MOVE

func death_state():
	velocity.x = 0
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/menu_1.tscn")

func _on_damage_received(enemy_damage):
	health -= enemy_damage
	if health <= 0:
		health = 0
		state = DEATH
	else:
		state = DAMAGE	
	emit_signal("health_changed", health)


func _on_hit_box_area_entered(area):
	Signals.emit_signal("hero_attack", damage_basic)
