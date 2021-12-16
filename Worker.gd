extends KinematicBody

enum State {
	SEARCHING,
	CHASING,
	DISPOSING,
	STUNNED,
}

export var max_grip = 0.2
export var stun_length = 5.0
export var perception_time = 8.0

var path = []
var path_node = 0
var max_speed = 6.0

var points_of_interest = []
var recycling_bins = []

var _target

onready var state = State.SEARCHING
onready var current_speed = max_speed
onready var grip = max_grip
onready var nav = get_parent()
onready var Player = $"../../Garbage/Player"
onready var MoveTimer = $MoveTimer
onready var StunTimer = $StunTimer
onready var PerceptionTimer = $PerceptionTimer


func _ready():
	for point in $"../PointsOfInterest".get_children():
		points_of_interest.push_back(point)
		
	_target = points_of_interest[0]

func _physics_process(delta):
	if state == State.STUNNED:
		pass
	else:			
		if path_node < path.size():
			var direction = (path[path_node] - global_transform.origin)
			if direction.length() < 1:
				path_node += 1
			else:
				move_and_slide(direction.normalized() * current_speed, Vector3.UP)


func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	look_at_from_position(global_transform.origin, Vector3(target_pos.x, global_transform.origin.y, target_pos.z), Vector3.UP)
	path_node = 0
	


func _on_MoveTimer_timeout():
	match state:
		State.CHASING:
			pass
		State.DISPOSING:
			pass
		State.SEARCHING:
			if (points_of_interest[0].global_transform.origin-global_transform.origin).length()<4.0:
				points_of_interest.shuffle()
				_target = points_of_interest[0]
	
	move_to(_target.global_transform.origin)


func struggle(amount):
	if amount > grip:
		max_grip = min(grip+0.1,0.9)
		grip=max_grip
		state = State.STUNNED
		StunTimer.start(stun_length)
		MoveTimer.stop()
		return true
	grip-=amount
	return false


func _on_PickupArea_body_entered(body):
	if body.get_parent().get_name()=="Garbage":
		if state != State.STUNNED:
			_target = pointsOfInterest[0]
			body.captured(self)
			state = State.DISPOSING


func _on_StunTimer_timeout():
	state = State.SEARCHING
	MoveTimer.start()


func _on_SenseRange_body_entered(body):
	if body.get_parent().get_name()=="Garbage" and state == State.SEARCHING:
		_target = body
		state = State.CHASING
	elif (body == _target and state == State.CHASING 
		and not PerceptionTimer.is_stopped()):
		PerceptionTimer.stop()
		

func _on_SenseRange_body_exited(body):
	if state == State.CHASING and body.get_name()==_target.get_name():
		PerceptionTimer.start(perception_time)


func _on_PerceptionTimer_timeout():
	_target = pointsOfInterest[0]
	state = State.SEARCHING

