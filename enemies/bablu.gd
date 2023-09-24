extends RigidBody2D

@export var bullet_scene: PackedScene
@export var bullet_variant = Constants.BULLET_VARIANTS.PLUS
@export var bullet_speed = 500
@export var fire_rate = 0.1
@export var rotation_torque = 800 * 50

var target: Player
var self_collision_layer

# Called when the node enters the scene tree for the first time.
func _ready():
	self_collision_layer = get_collision_layer()
	$AnimatedSprite2D.play()
	$AimIndicator.fire_rate = fire_rate
	$AimIndicator.bullet_speed = bullet_speed
	$AimIndicator.independent_rotation = false

	$EquationHolder.top_level = true
	position_equation_holder()

	rotate_default()


func rotate_default():
	add_constant_torque(rotation_torque)


# had to do this hack since the label is part of the rotating rigidbody
func position_equation_holder():
	$EquationHolder.global_position = global_position - Vector2(28, -41)
	$EquationHolder.rotation_degrees = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_equation_holder()

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
	$AimIndicator.bullet_variant = bullet_variant
	$AimIndicator.shoot()


func handle_being_shot_at(identity):
	print("I'm being shot at bby", identity)
	if identity.type == Constants.NODE_TYPES.BULLET:
		if !is_in_group(identity.shooter_group):
			if identity.variant == Constants.BULLET_VARIANTS.MINUS:
				$EquationHolder.decrement_selected_operand()
			else:
				$EquationHolder.increment_selected_operand()

	

func handle_equation_operand_switch(operand_num):
	$EquationHolder.switch_operand(operand_num)


func handle_equation_death():
	print("dbed")
	die()


func die():
	queue_free()

	
func handle_bullet_variant_change(variant):
	bullet_variant = variant



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
