extends Spatial

enum {
	CRUSH,
	RECOVER,
	HIT,
}

export var crush_speed = 0.1
export var recover_speed = 1.0


var _lerp_pos = 0.0

onready var default_location = $KinematicBody.transform.origin
onready var down_location = $KinematicBody.transform.origin - Vector3(0,1,0)
onready var CrushTimer = $CrushTimer
onready var RecoverTimer = $RecoverTimer
onready var _crush = HIT


func _physics_process(delta):
	match _crush:
		CRUSH:
			_lerp_pos = min(_lerp_pos+delta/crush_speed,1.0)
		RECOVER:
			_lerp_pos = max(_lerp_pos-delta/crush_speed,0.0)
		
			
	$KinematicBody.transform.origin = lerp(default_location, down_location, _lerp_pos)
	if _lerp_pos<0.01 and CrushTimer.is_stopped():
		CrushTimer.start()
	elif _lerp_pos>0.99 and RecoverTimer.is_stopped():
		RecoverTimer.start()
		

func _on_CrushTimer_timeout():
	_crush = CRUSH


func _on_RecoverTimer_timeout():
	_crush = RECOVER


func _on_Area_body_entered(body):
	if _crush != HIT:
		if RecoverTimer.is_stopped() and CrushTimer.is_stopped() and _lerp_pos<0.7:
			_crush=HIT
			RecoverTimer.start()
			
		if body.get_name()=="Player":
			body.compress()
