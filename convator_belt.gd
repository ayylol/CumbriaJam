extends Spatial

export var belt_speed = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody.constant_linear_velocity = -global_transform.basis.z*belt_speed
