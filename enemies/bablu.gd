extends RigidBody2D

@export var bullet_scene: PackedScene
@export var bullet_speed = 500
@export var fire_rate = 0.1
@export var rotation_torque = 500

var target: Player
var self_collision_layer

# Called when the node enters the scene tree for the first time.
func _ready():
	self_collision_layer = get_collision_layer()
	$AnimatedSprite2D.play()
	$AimIndicator.independent_rotation = false
	rotate_default()


func rotate_default():
	add_constant_torque(rotation_torque)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider is Player:
			target = collider
		else:
			target = null
	else:
		target = null
		
	if target:
		look_and_shoot_at_target()
	elif rotation_torque == 0:
		rotate_default()


func look_and_shoot_at_target():
	rotation_torque = 0
	look_at(target.global_position)
	shoot()

func shoot():
	$AimIndicator.shoot()


func handle_being_shot_at():
	print("I'm being shot at bby")
	die()
	

func die():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
