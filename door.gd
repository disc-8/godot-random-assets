#this needs pretty spesiffix nodes:
# rotation pivot - regular spatial
# da model itself, goes on edge of spatial
 # interaction area, under layer 2 along with players interaction area on layer2. 
extends Spatial

onready var rotpivot=$rotpivot
var STATE=0 # 1 - open; 0 - closed
var canopen = 0
var targetang=0.0
export var openang=70.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	rotpivot.rotation.y = lerp_angle(rotpivot.rotation.y, targetang, 0.04)
	if Input.is_action_just_pressed("interact") and canopen == 1:
		match(STATE):
			1:
				targetang=deg2rad(0.0)
				STATE=0
			0:
				targetang=deg2rad(openang)
				STATE=1


func _on_open_area_area_entered(area):
	print("test")
	canopen = 1

func _on_open_area_area_exited(area):
	canopen = 0
