extends KinematicBody

export var grip = 0.2
export var stun_length = 10.0

var path = []
var path_node = 0

var max_speed = 4.0

var _can_grab = true

onready var _stunned = stun_length
onready var current_speed = max_speed
onready var nav = get_parent()
onready var player = $"../../Garbage/Player"

func _physics_process(delta):
	_stunned = min(_stunned + delta, stun_length)
	if _stunned >= stun_length:
		current_speed = max_speed
		_can_grab=true
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			#print("Moving")
			move_and_slide(direction.normalized() * current_speed, Vector3.UP)
	
func move_to(target_pos):
	#print("Calculating path to" + str(target_pos))
	path = nav.get_simple_path(global_transform.origin, target_pos)
	look_at_from_position(global_transform.origin, Vector3(target_pos.x, global_transform.origin.y, target_pos.z), Vector3.UP)
	path_node = 0
	


func _on_Timer_timeout():
	move_to(player.global_transform.origin)

func struggle(amount):
	if amount > grip:
		return true
		#grip = min(grip+0.1,0.9)
		current_speed=0.0
		_stunned = 0.0
		_can_grab = false
	return false


func _on_PickupArea_body_entered(body):
	if body.get_parent().get_name()=="Garbage":
		if body.get_name()=="Player" and _can_grab:
			body.captured(self)
	#print(str(body.get_parent().get_name())+"ENTERED AREA")
