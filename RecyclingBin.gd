extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BinHit_body_entered(body):
	if body.get_parent().name.begins_with("Garbage"):
		body.die()


func _on_WorkerHit_body_entered(body):
	pass # Replace with function body.
