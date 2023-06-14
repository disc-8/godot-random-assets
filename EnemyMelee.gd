extends KinematicBody2D


export (float) var speed = 30
export (int) var hp = 3
var velocity = Vector2.ZERO

var path: Array = []

var level_nav
var player

func _ready():
	level_nav = get_tree().get_nodes_in_group("Nav")[0]
	player = get_tree().get_nodes_in_group("Player")[0]

func nav():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		
		if global_position == path[0]:
			path.pop_front()

func gen_path():
	if level_nav != null and player != null:
		path = level_nav.get_simple_path(global_position, player.global_position, false)

func _physics_process(delta):
	gen_path()
	nav()
	move_and_slide(velocity)
	
func hurt(damage):
	hp -= damage
	if hp <= 0 :
		queue_free()
