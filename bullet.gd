extends RigidBody2D

# reuse this for almost all kinds of bullets (I assume auto aim won't work with this)

@export var shooter_group: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if !body.is_in_group(shooter_group):
		if "handle_being_shot_at" in body:
			body.handle_being_shot_at()
		queue_free()
	
