extends RigidBody2D

enum BuntyVariants {
	CROSS,
	PLUS,
}

var variant_switch_rate_seconds = 1.5
var active_variant = BuntyVariants.CROSS

# Called when the node enters the scene tree for the first time.
func _ready():
	$VariantTimer.start(variant_switch_rate_seconds)
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	print("bunty body entered", body)
	


func _on_area_entered(area):
	print("bunty area entered", area)


func handle_being_shot_at():
	print("I'm being shot at bby")
	queue_free()


func _on_timer_timeout():
	active_variant = BuntyVariants.CROSS if active_variant != BuntyVariants.CROSS else BuntyVariants.PLUS
	if active_variant == BuntyVariants.CROSS:
		$AnimatedSprite2D.animation = "bunty_cross"
	else:
		$AnimatedSprite2D.animation = "bunty_plus"
	
	$VariantTimer.start(variant_switch_rate_seconds)
