extends Spatial

var camrot_h = 0
var camrot_v = 0

var _mouseTrapped = false
var _player 

# From Tutorial: https://www.youtube.com/watch?v=Bch-OagnX1E
func _ready():
	_player = get_parent().get_node("Player")
	$H/V/Camera.add_exception(_player)

func _input(event):
	if event.is_action_pressed("ui_cancel") and _mouseTrapped:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_mouseTrapped=false
	elif event.is_action_pressed("mouse_click") and not _mouseTrapped:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_mouseTrapped=true

	if event is InputEventMouseMotion and _mouseTrapped:
		camrot_h -= event.relative.x
		camrot_v = clamp(camrot_v-event.relative.y,-60,60)
		
	if event.is_action_pressed("push"):
		_player.hold()
	elif event.is_action_released("push"):
		_player.release(-$H/V/Camera.global_transform.basis.z)

func _physics_process(delta):
	$H.rotation_degrees.y = camrot_h
	$H/V.rotation_degrees.x = camrot_v
