# consider using a CharacterBody because ship will thrust and drift etc later
extends Area2D

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("shoot"):
		$AimIndicator.shoot()
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
		if($AnimatedSprite2D.animation == "idle"):
			if(velocity.y != 0):
				$AnimatedSprite2D.animation = "up_transition" if velocity.y < 0 else "down_transition"

			if(velocity.x != 0):
				$AnimatedSprite2D.animation = "left_transition" if velocity.x < 0 else "right_transition"
					
			if(velocity.x != 0 and velocity.y != 0):
				if(velocity.y < 0):
					$AnimatedSprite2D.animation = "top_left_transition" if velocity.x < 0 else "top_right_transition"
				if(velocity.y > 0):
					$AnimatedSprite2D.animation = "bottom_left_transition" if velocity.x < 0 else "bottom_right_transition"
		
		# puke
		var animationNameSplitArr = $AnimatedSprite2D.animation.split("_")
		if(animationNameSplitArr.size() == 1 or (animationNameSplitArr.size() != 3 and $AnimatedSprite2D.animation.ends_with("transition"))):
			if(velocity.x != 0 and velocity.y != 0):
				if(velocity.y < 0):
					$AnimatedSprite2D.animation = "top_left_transition" if velocity.x < 0 else "top_right_transition"
				if(velocity.y > 0):
					$AnimatedSprite2D.animation = "bottom_left_transition" if velocity.x < 0 else "bottom_right_transition"
	else:
		if($AnimatedSprite2D.animation == "up"):
			$AnimatedSprite2D.animation = "up_transition_reverse"
		elif($AnimatedSprite2D.animation == "down"):
			$AnimatedSprite2D.animation = "down_transition_reverse"
		elif($AnimatedSprite2D.animation == "right"):
			$AnimatedSprite2D.animation = "right_transition_reverse"
		elif($AnimatedSprite2D.animation == "left"):
			$AnimatedSprite2D.animation = "left_transition_reverse"
		elif($AnimatedSprite2D.animation == "top_left"):
			$AnimatedSprite2D.animation = "top_left_transition_reverse"
		elif($AnimatedSprite2D.animation == "top_right"):
			$AnimatedSprite2D.animation = "top_right_transition_reverse"
		elif($AnimatedSprite2D.animation == "bottom_left"):
			$AnimatedSprite2D.animation = "bottom_left_transition_reverse"
		elif($AnimatedSprite2D.animation == "bottom_right"):
			$AnimatedSprite2D.animation = "bottom_right_transition_reverse"

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


# don't think this should be converted to rigidbody as it'll require
# time to perfect movement, for now this is good enough, and the 
# _on_body_entered -> identify_self thing should be good enough for now
func handle_being_shot_at():
	print("player shot")
	die()


func die():
	queue_free()

func _on_animated_sprite_2d_animation_finished():
	if($AnimatedSprite2D.animation.ends_with("transition")):
		$AnimatedSprite2D.animation = $AnimatedSprite2D.animation.trim_suffix("_transition")
		$AnimatedSprite2D.play();
	
	if($AnimatedSprite2D.animation.ends_with("reverse")):
		$AnimatedSprite2D.animation = "idle";
		$AnimatedSprite2D.play();



func _on_body_entered(body):
	if "identify_self" in body:
		var body_metadata = body.identify_self()
		if body_metadata.type == Constants.NODE_TYPES.BULLET:
			if !is_in_group(body.shooter_group):
				die()
	
