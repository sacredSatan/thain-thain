extends Node2D

@export var bunty_scene: PackedScene

# clean up later
@export var enemy_spawn_rate = 3
@export var enemy_speed_min = 150
@export var enemy_speed_max = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.start(enemy_spawn_rate)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# would handle more enemies if I had them
func _on_enemy_spawn_timer_timeout():
	var bunty = bunty_scene.instantiate()
	var bunty_spawn_location = $EnemySpawnPath/EnemySpawnLocation
	# progress to a random point (this is the same as dodge the creeps)
	bunty_spawn_location.progress_ratio = randf()
	
	# perpendicular
	var direction = bunty_spawn_location.rotation + deg_to_rad(90)
	bunty.position = bunty_spawn_location.position

	# randomness in direction
	direction += randf_range(deg_to_rad(-45), deg_to_rad(45))
	bunty.rotation = direction
	
	var velocity = Vector2(randf_range(enemy_speed_min, enemy_speed_max), 0.0)
	bunty.linear_velocity = velocity.rotated(direction)
	
	add_child(bunty)
