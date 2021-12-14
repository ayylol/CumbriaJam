extends RigidBody

#export var push_cooldown = 1.5
export var max_pushes = 4
export var meter_fill_multipliyer = 2.0
export var pressure_fill_multipliyer = 1.0

var max_strength = 25

var _current_pushed = 0.0
var _meter_percent_fill = 0.0
var _held = false

#func _ready():
#	pass
	#$Timer.start(push_cooldown)

func _process(delta):
	_meter_percent_fill= min(_meter_percent_fill+delta/meter_fill_multipliyer, 1.0)
	if _held:
		_current_pushed = min(_current_pushed+delta/pressure_fill_multipliyer, _meter_percent_fill)
	print(_meter_percent_fill)
	print(_current_pushed)
	print()

func hold():
	print("HELD")
	_held = true

func release(direction: Vector3):
	print("PUSHED!")
	_held=false
	if _meter_percent_fill>0.0:
		var _time_held
		apply_central_impulse (direction*max_strength*_current_pushed)
		_meter_percent_fill-=_current_pushed
		_current_pushed=0.0
#		_current_pushes-=1
#		if($Timer.is_stopped()):
#			$Timer.start(push_cooldown)

#func _on_Timer_timeout():
#	if _current_pushes<max_pushes:
#		_current_pushes+=1
#		if _current_pushes!=max_pushes:
#			$Timer.start(push_cooldown)
#	print(_current_pushes)
