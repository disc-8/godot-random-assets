extends KinematicBody2D

const UP_DIR := Vector2.UP

export (float) var speed = 100
export (float) var jump_str = 250
export (int) var jumpcount = 2
export (float) var sjump_str = 230
export (float) var gravity = 1200

var _jumps_done = 0
var _velocity = Vector2.ZERO

onready var ap = $AnimationPlayer
onready var sp = $SpritePoint
var default_scale

func _ready():
	default_scale = sp.scale

func _physics_process(delta):
	var _h_dir = (Input.get_action_strength("right") - Input.get_action_strength("left"))
	_velocity.x = _h_dir * speed
	_velocity.y += gravity * delta
	
	#good vars to just have
	var is_falling = _velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_sjumping = Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_idle = is_on_floor() and is_zero_approx(_velocity.x)
	var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
	
	if is_idle:
		ap.play("idle")
	elif is_running:
		ap.play("run")
	
	if is_falling:
		ap.play("fall")
	
	if is_jumping:
		ap.play("jump")
		_jumps_done += 1
		_velocity.y = -jump_str
	elif is_sjumping:
		ap.play("jump")
		_jumps_done += 1
		if _jumps_done < jumpcount:
			_velocity.y = -sjump_str
	elif is_jump_cancelled:
		_velocity.y = 0.0
	
	if is_idle or is_running:
		_jumps_done = 0
	
	_velocity = move_and_slide(_velocity, UP_DIR)
	
	if not is_zero_approx(_velocity.x):
		sp.scale.x = sign(_velocity.x) * default_scale.x
