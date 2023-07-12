extends Area2D

export (float) var speed = 750
var damage = 10

func _physics_process(delta):
	position += transform.x * speed * delta
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		if bodies[0].has_method("hurt"):
			bodies[0].hurt(damage)
		queue_free()


func _on_Timer_timeout():
	queue_free()
