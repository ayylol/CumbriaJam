extends RigidBody

export var push_cooldown = 4
export var max_pushes = 4

var strength = 10

var _current_pushes = 0

func _ready():
	$Timer.start(push_cooldown)

func push(direction: Vector3):
	if _current_pushes>0:
		print("PUSHED!")
		apply_central_impulse (direction*strength)
		_current_pushes-=1
		if($Timer.is_stopped()):
			$Timer.start(push_cooldown)

func _on_Timer_timeout():
	if _current_pushes<max_pushes:
		_current_pushes+=1
		if _current_pushes!=max_pushes:
			$Timer.start(push_cooldown)
	print(_current_pushes)
