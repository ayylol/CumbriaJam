extends RigidBody

#export var push_cooldown = 1.5
export var max_pushes = 4
export var meter_fill_multipliyer = 5.0
export var pressure_fill_multipliyer = 2.5

var max_strength = 15

var _current_pushed = 0.0
var _meter_percent_fill = 0.0
var _held = false

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

func compress(direction: Vector3):
	pass
