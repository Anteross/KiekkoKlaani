extends KinematicBody2D

signal item_collected(item_type)
signal health_left(health_left)

const MAX_SPEED = 300
const SLIDE_SPEED = 500
const JUMP_HEIGHT = -350
const ACCELERATION = 25
const FRICTION = 0.05
const AIR_FRICTION = 0.2
const DAMAGE_STAGGER = 150
const UP = Vector2(0,-1)

var gravity = 10
var max_health = 5
var current_health = 5
var coins = 0
var motion = Vector2()

func _ready():
	emit_signal("health_left", current_health)

func _physics_process(delta):
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		move(ACCELERATION, false)
	elif Input.is_action_pressed("ui_left"):
		move(-ACCELERATION, true)
	elif Input.is_action_pressed("ui_slide") and is_on_floor():
		play_animation("Slide")
		if motion.x < 0:
			motion.x = lerp(-SLIDE_SPEED, 0, FRICTION)
		elif motion.x > 0:
			motion.x = lerp(SLIDE_SPEED, 0, FRICTION)
			
	elif is_on_floor():
		friction = true
		play_animation("Idle")
	
	if is_on_wall():
		gravity = 2
		if Input.is_action_pressed("ui_up"):
			Input.action_release("ui_left")
			motion.y = JUMP_HEIGHT
			motion.x = 200
	else:
		gravity = 10
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
	else:
		if motion.y < 0:
			play_animation("Jump")
		else:
			play_animation("Fall")
		if friction:
			motion.x = lerp(motion.x, 0, FRICTION)
	motion = move_and_slide(motion, UP)

func move(var speed, var flip):
	if(motion.x < 0):
		motion.x = max(motion.x + speed, -MAX_SPEED)
	else:
		motion.x = min(motion.x + speed, MAX_SPEED)
	$Sprite.flip_h = flip
	if is_on_floor():
		play_animation("Run")

func take_damage(var damagePosX, var amount):
	set_modulate(Color(1,0.3,0.3,1))
	motion.y = JUMP_HEIGHT * 0.4
	
	current_health -= amount
	emit_signal("health_left", current_health)
	
	if position.x < damagePosX:
		motion.x = -DAMAGE_STAGGER
	elif position.x > damagePosX:
		motion.x = DAMAGE_STAGGER
	
	$StaggerTimer.start()
	Input.action_release("ui_left")
	Input.action_release("ui_right")

func bounce():
	motion.y = JUMP_HEIGHT * 0.6

func add_coin():
	emit_signal("item_collected", "Coin")

func play_animation(var animation):
	$Sprite.play(animation)

func _on_FallZone_body_entered(body):
	get_tree().change_scene("res://TitleMenu.tscn")

func _on_StaggerTimer_timeout():
	set_modulate(Color(1,1,1,1))

