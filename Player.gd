extends RigidBody

#export var push_cooldown = 1.5
export var max_pushes = 4
export var meter_fill_multipliyer = 5.0
export var pressure_fill_multipliyer = 2.5
export var default_hitbox_size = Vector3(1,1,1)
export var default_mesh_size = Vector3(0.319,0.319,0.319)
export var decompress_time = 8.0
export var stain_time = 10.0
export var stain_per = 0.01

var max_strength = 15
var can_move = true

var _current_pushed = 0.0
var _meter_percent_fill = 0.0
var _held = false
var _scale_lerp = 1.0
var _stain_lerp = 1.0

var _shrunk_hitbox = Vector3(1,1,1)
var _shrunk_mesh = Vector3(1,1,1)
var _worker


func _init():
	_shrunk_hitbox=default_hitbox_size*0.3
	_shrunk_mesh=default_mesh_size*0.3

func _physics_process(delta):
	if _worker != null:
		global_transform.origin = _worker.global_transform.origin+Vector3(0,0,1.5)
	
	#Updating stain variables
	_stain_lerp=min(_stain_lerp+delta/stain_time,1.0)
	
	#updating push variables
	_meter_percent_fill= min(_meter_percent_fill+(delta/meter_fill_multipliyer)*_stain_lerp, pow(_scale_lerp,2))
	if _held:
		_current_pushed = min(_current_pushed+(delta/pressure_fill_multipliyer)*_stain_lerp, _meter_percent_fill)
	
	#Updating Crushing variables
	$CollisionShape.scale = _shrunk_hitbox.linear_interpolate(default_hitbox_size,_scale_lerp)
	$Spatial.scale = _shrunk_mesh.linear_interpolate(default_mesh_size,_scale_lerp)
	_scale_lerp=min(_scale_lerp+delta/decompress_time,1.0)
	

	print(_meter_percent_fill)
	print(_current_pushed)
	#print(_scale_lerp)

func hold():
	#print("HELD")
	_held = true

func release(direction: Vector3):
	#print("PUSHED!")
	#print(direction)
	_held=false
	if _worker == null:
		apply_central_impulse (direction*max_strength*_current_pushed)	
	else:
		if _worker.struggle(_current_pushed):
			_worker = null
			apply_central_impulse (direction*max_strength*_current_pushed)	
	_meter_percent_fill-=_current_pushed
	_current_pushed=0.0

func compress():
	_scale_lerp=0.0
	
func stain():
	_stain_lerp=stain_per
 
func captured(worker):
	_worker = worker
