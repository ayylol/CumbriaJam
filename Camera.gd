extends Spatial

var camrot_h = 0
var camrot_v = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$H/V/Camera.add_exception(get_parent().get_node("Player"))

func _input(event):
	if event is InputEventMouseMotion:
		camrot_h -= event.relative.x
		camrot_v -= event.relative.y

func _physics_process(delta):
	$H.rotation_degrees.y = camrot_h
	$H/V.rotation_degrees.x = camrot_v
