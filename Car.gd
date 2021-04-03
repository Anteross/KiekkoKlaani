extends KinematicBody2D

const GRAVITY = 10
const UP = Vector2(0,-1)
var motion = Vector2()

func _ready():
	$AnimatedSprite.flip_h = true

func _physics_process(delta):
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
