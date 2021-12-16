extends StaticBody

onready var _in_hitbox = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for garbage in _in_hitbox:
		print(garbage.get_name())
		print(garbage.state == 1)
		if garbage.state == 1:
			garbage.die()


func _on_BinHit_body_entered(body):
	if body.get_parent().name.begins_with("Garbage"):
		body.die()


func _on_WorkerHit_body_entered(body):
	if (body.get_parent().name.begins_with("Garbage") and not _in_hitbox.has(body)):
		_in_hitbox.push_back(body)

func _on_WorkerHit_body_exited(body):
	if _in_hitbox.has(body):
		_in_hitbox.erase(body)
