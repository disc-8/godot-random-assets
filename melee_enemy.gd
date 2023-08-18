extends KinematicBody2D


var player 
export (float) var damage = 12.0
export (float) var speed = 75
var velocity = Vector2.ZERO
export (float) var hp = 30.0
var can_move = true
var can_attack = false
var dtp 
onready var windup = $WindUp
export (float) var min_distance = 15.0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


func _physics_process(delta):
	dtp = player.global_position - global_position
	if is_instance_valid(player) and can_move:
		if dtp.length() <= min_distance:
			can_move = false
			can_attack = true
			return
		velocity = Vector2.ZERO
		velocity = dtp.normalized()
		velocity = move_and_slide(velocity * speed)
	if can_attack:
		attack(damage)

func attack(dmg):
	can_attack = false
	windup.start()
	yield(windup, "timeout")
	if dtp.length() <= min_distance:
		player.hurt(dmg)
	can_move = true

func hurt(dmg):
	$AnimationPlayer.play("hurt")
	hp -= dmg
	if hp <= 0:
		queue_free()
