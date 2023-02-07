extends KinematicBody

export var walk_speed = 15
export var h_accel = 10
export var gravity = 20
export var jump = 10
var h_vel = Vector3()
var movement = Vector3()
var dir = Vector3()
var gravity_vec = Vector3()
onready var ground_check = $GroundCheck
var full_contact = false

export var mouse_sens = 0.3

onready var head = $Head

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sens))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -89, 89)

func _physics_process(delta):
	dir = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	elif is_on_floor() and not full_contact:
		gravity_vec = -get_floor_normal()*gravity
	else:
		gravity_vec = -get_floor_normal()
	
	if Input.is_action_pressed("forward"):
		dir -= transform.basis.z
	elif Input.is_action_pressed("backward"):
		dir += transform.basis.z
	if Input.is_action_pressed("left"):
		dir -= transform.basis.x
	elif Input.is_action_pressed("right"):
		dir += transform.basis.x
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	
	dir = dir.normalized()
	h_vel = h_vel.linear_interpolate(dir*walk_speed, h_accel*delta)
	movement.z = h_vel.z + gravity_vec.z
	movement.x = h_vel.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
