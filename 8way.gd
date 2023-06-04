extends KinematicBody2D

export (float) var speed = 15.0
var velocity = Vector2.ZERO

func movement():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("forward"):
		velocity.y -= 1
	if Input.is_action_pressed("backward"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	movement()
	velocity = move_and_slide(velocity)
