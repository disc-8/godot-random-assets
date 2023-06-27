extends Area2D

var tile_size = 32
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

onready var ray = $RayCast2D
onready var tween = $Tween
export (float) var move_speed = 5

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	if tween.is_active():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.cast_to = inputs[dir] *tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		move_tween(dir)

func move_tween(dir):
	tween.interpolate_property(self, "position", position, position + inputs[dir] * tile_size, 1.0/move_speed,Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
