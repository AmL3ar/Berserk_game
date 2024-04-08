extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
@onready var animation = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var last_key_pressed: String = "IdleRight"

func controller(delta):
	var vel = velocity
	
	if (!is_on_floor()):
		vel.y += gravity * delta
		
	if (Input.is_action_just_pressed("ui_accept") && is_on_floor()):
		vel.y = JUMP_VELOCITY
		
	if (Input.is_action_pressed("ui_right")):
		vel.x = SPEED
	if (Input.is_action_pressed("ui_left")):
		vel.x = -SPEED
		
	if (Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left")):
		vel.x = 0
			
		
	velocity = vel
		
	updateSpriteRenderer(vel.x,vel.y)	
	move_and_slide()
	
func updateSpriteRenderer(velX:float,velY:float):
	var running = velX != 0
	var jumping = velY != 0
	
	if (running && !jumping):
		animation.play("RunRight")
		last_key_pressed = "IdleRight"
		if velX < 0:
			animation.flip_h = true
			last_key_pressed = "IdleLeft"
	elif (jumping):
		if velY < 300:
			animation.play("JumpRightUp")
		else:
			animation.play("JumpRightDown")
		if velX < 0 || last_key_pressed == "IdleLeft":
			if velY < 300:
				animation.play("JumpLeftUp")
			else:
				animation.play("JumpLeftDown")
		animation.stop()
	else:
		animation.play(last_key_pressed)
	
		
func _physics_process(delta):
	controller(delta)

	
