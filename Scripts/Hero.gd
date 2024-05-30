extends CharacterBody2D

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
@onready var stats = $Stats

var curr_dir = "IdleRight"
var state = MOVE
var activate_R = false
var damage_basic = 50


var hero_pos

func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))

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
			$AnimatedSprite2D.flip_h = false
			animation.play("RunRight")
			rotation_hitbox(rotate, hitbox, 0, 0, 0, 0)	
			curr_dir = "IdleRight"
		elif velocity.y == 0:
			$AnimatedSprite2D.flip_h = true
			animation.play("RunRight")
			rotation_hitbox(rotate, hitbox, -45, 13, -15, 180)
			curr_dir = "IdleLeft"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play(curr_dir)
	
	
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		stats.stamina_cost = stats.attack_cost
		if stats.stamina_cost < stats.stamina:
			state = EASYATTACK
	if Input.is_action_just_pressed("R"):
		activate_R = true
	if Input.is_action_just_pressed("U"):
		animation.play("ConanRight")

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
	get_tree().change_scene_to_file("res://Scenes/lose_menu.tscn")

func _on_damage_received(enemy_damage):
	stats.health -= enemy_damage
	if stats.health <= 0:
		stats.health = 0
		state = DEATH
	else:
		state = DAMAGE

func rotation_hitbox(rotate, hitbox, x, y, HB_y, angle):
	rotate.rotation_degrees = angle
	rotate.position.x = x
	rotate.position.y = y
	hitbox.position.y = HB_y

func _on_hit_box_area_entered(area):
	if activate_R:
		Signals.emit_signal("hero_attack", damage_basic * 2)
		activate_R = false
	else:
		Signals.emit_signal("hero_attack", damage_basic)
