extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	HARD_ATTACK,
	AWAKENING,
	DAMAGE,
	RECOVER,
	DEATH
}
var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			HARD_ATTACK:
				hard_attack_state()
			AWAKENING:
				awakening_state()
			DAMAGE:
				damage_state()
			RECOVER:
				recover_state()
			DEATH:
				death_state()
				

@onready var health_bar = $Health_bar_boss
@onready var animated_sprite = $AnimationPlayer
@onready var collision = $AttackDirection/AttackRange/CollisionShape2D
@onready var music = $"../AudioStreamPlayer"

var is_awake: bool = false
var damage = 40
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var audioStream: AudioStream

func _ready():
	audioStream = preload("res://Music/My Brother - Berserk _ 16-Bit (256  kbps).mp3")
	health_bar.visible = false
	Signals.connect("hero_attack", Callable(self, "_on_damage_received"))

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_detect_area_body_entered(body):
	if body.is_in_group("Hero"):
		if not is_awake:
			music.stream = audioStream
			music.play()
			health_bar.visible = true
			state = AWAKENING


func _on_attack_range_body_entered(body):
	pass

func idle_state():
	animated_sprite.play("Idle")
	collision.disabled = false
	state = ATTACK

func attack_state():
	pass

func hard_attack_state():
	pass

func damage_state():
	pass

func recover_state():
	pass

func death_state():
	get_tree().change_scene_to_file("res://Scenes/win_menu.tscn")

func awakening_state():
	animated_sprite.play("Awakening")
	await animated_sprite.animation_finished
	is_awake = true
	state = IDLE

func _on_damage_received(player_damage):
	health_bar.health -= player_damage
	if health_bar.health < 1 :
		state = DEATH
	else:
		state = DAMAGE
