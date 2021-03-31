extends KinematicBody2D

const GRAVITY = 10

export var direction = -1
export var detectsCliffs = true
var velocity = Vector2()
var speed = 50

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	check_floor()

func _physics_process(delta):
	velocity.y += GRAVITY
	
	if is_on_wall() or not $FloorChecker.is_colliding() and detectsCliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		check_floor()
	
	velocity.x = speed * direction
	
	velocity =  move_and_slide(velocity, Vector2.UP)

func check_floor():
	if(detectsCliffs):
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	else:
		$FloorChecker.enabled = detectsCliffs

func _on_TopChecker_body_entered(body):
	$AnimatedSprite.play("Squished")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$TopChecker.set_collision_layer_bit(4, false)
	$TopChecker.set_collision_mask_bit(0, false)
	$SidesChecker.set_collision_layer_bit(4, false)
	$SidesChecker.set_collision_mask_bit(0, false)
	$BottomChecker.set_collision_layer_bit(4, false)
	$BottomChecker.set_collision_mask_bit(0, false)
	$Timer.start()
	body.bounce()

func _on_SidesChecker_body_entered(body):
	body.take_damage(position.x)

func _on_Timer_timeout():
	queue_free()

func _on_BottomChecker_body_entered(body):
	body.take_damage(position.x)
