#nodes:
#Node
#	Thugshaker(tween)
#	Freq(timer)
#	Duration(timer)

#connect timer signals

extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT


export (float) var amplitude = 0.0
var priority = 0.0
onready var s = $ShakeBaby
onready var f = $Freq
onready var camera = get_parent()

func shakeem(duration = 0.2, freq = 15, amp = 16, priority = 0.0):
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amp
		$Duration.wait_time = duration 
		f.wait_time = 1/float(freq)
		$Duration.start()
		f.start()
		_new_shake()

func _new_shake():
	randomize()
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	s.interpolate_property(camera, "offset", camera.offset, rand, f.wait_time, TRANS, EASE )
	s.start()


func _on_Freq_timeout():
	_new_shake()


func _on_Duration_timeout():
	s.interpolate_property(camera, "offset", camera.offset, Vector2(), f.wait_time, TRANS, EASE )
	s.start()
	f.stop()
	priority = 0
