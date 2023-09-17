# has basically become a gun

extends Node2D
@export var bullet_scene: PackedScene
@export var bullet_speed = 500
@export var fire_rate = 0.1

var can_shoot = true



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())

func shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate()
		bullet.shooter_group = "player"
		bullet.position = $Gun.get_global_position()
		bullet.rotation_degrees = rotation_degrees
		bullet.apply_central_impulse(Vector2(bullet_speed, 0).rotated(rotation))
		
		get_tree().get_root().add_child(bullet)
		$FireRateTimer.start(fire_rate)
		can_shoot = false


func _on_fire_rate_timer_timeout():
	can_shoot = true
