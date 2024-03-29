# has basically become a gun

extends Node2D
@export var bullet_scene: PackedScene
@export var indicator_variant = Constants.AIM_INDICATOR_VARIANTS.CIRCULAR
@export var bullet_speed = 500
@export var fire_rate = 0.1
@export var shooter_group = "player"
@export var bullet_variant = Constants.BULLET_VARIANTS.MINUS
@export var independent_rotation = true

var shooter
var shooter_collision_layer
var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	shooter = get_parent()
	if shooter:
		shooter_collision_layer = shooter.get_collision_layer()
		
	if indicator_variant == Constants.AIM_INDICATOR_VARIANTS.CIRCULAR:
		$AnimatedSprite2D.animation = "aim_indicator_circular"

	if indicator_variant == Constants.AIM_INDICATOR_VARIANTS.ARROW_HAND_DASHED:
		$AnimatedSprite2D.animation = "aim_indicator_arrow_hand_dashed"

	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	look_at(get_global_mouse_position())
	pass

func shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate()
		if shooter_collision_layer:
			# setting the layer too makes it so that player's bullets can kill enemy's bullets
			# ramayan style
			bullet.set_collision_layer(bullet.get_collision_layer() + shooter_collision_layer)
			bullet.set_collision_mask(bullet.get_collision_mask() - shooter_collision_layer)
		bullet.variant = bullet_variant
		bullet.shooter_group = shooter_group
		bullet.position = $Gun.get_global_position()
		bullet.rotation_degrees = rotation_degrees if independent_rotation else shooter.rotation_degrees
		bullet.apply_central_impulse(Vector2(bullet_speed, 0).rotated(rotation if independent_rotation else shooter.rotation))
		
		get_tree().get_root().add_child(bullet)
		$FireRateTimer.start(fire_rate)
		can_shoot = false


func _on_fire_rate_timer_timeout():
	can_shoot = true
