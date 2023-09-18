extends RigidBody2D
@export var bullet_scene: PackedScene
@export var bullet_speed = 500
@export var fire_rate = 0.1


enum BuntyVariants {
	CROSS,
	PLUS,
}

var bunty_collision_layer
var variant_switch_rate_seconds = 1.5
var active_variant = BuntyVariants.CROSS

# Called when the node enters the scene tree for the first time.
func _ready():
	$VariantTimer.start(variant_switch_rate_seconds)
	$AnimatedSprite2D.play()
	bunty_collision_layer = get_collision_layer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot(times: int):
	if(times < 1):
		return

	var guns = $GunPlus.get_children() if active_variant == BuntyVariants.PLUS else $GunCross.get_children()
	for gun in guns:
		var bullet = bullet_scene.instantiate()
		bullet.set_collision_mask(bullet.get_collision_mask() - bunty_collision_layer)
		bullet.set_collision_layer(bullet.get_collision_layer() + bunty_collision_layer)
		bullet.shooter_group = "enemy"
		bullet.variant = "bullet_plus"
		bullet.position = gun.get_global_position()
		bullet.rotation_degrees = gun.rotation_degrees + rotation_degrees
		bullet.apply_central_impulse(Vector2(bullet_speed, 0).rotated(gun.rotation + rotation))
		get_tree().get_root().add_child(bullet)
	
	$FireRateTimer.start(fire_rate)
	await $FireRateTimer.timeout
	shoot(times - 1)


func _on_body_entered(body):
	print("bunty body entered", body)


func _on_area_entered(area):
	print("bunty area entered", area)


func handle_being_shot_at():
	print("I'm being shot at bby")
	die()
	

func die():
	queue_free()


func _on_timer_timeout():
	active_variant = BuntyVariants.CROSS if active_variant != BuntyVariants.CROSS else BuntyVariants.PLUS
	if active_variant == BuntyVariants.CROSS:
		$AnimatedSprite2D.animation = "bunty_cross"
	else:
		$AnimatedSprite2D.animation = "bunty_plus"
	
	shoot(4)
#	$VariantTimer.start(variant_switch_rate_seconds)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
