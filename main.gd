extends Node2D

@export var bunty_scene: PackedScene
@export var bablu_scene: PackedScene

# clean up later
@export var enemy_spawn_rate = 5
@export var enemy_speed_min = 150
@export var enemy_speed_max = 250


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_random_enemy()
	$EnemySpawnTimer.start(enemy_spawn_rate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_random_enemy():
	var enemy_scene = bablu_scene if randf() > 0.5 else bunty_scene
	
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = $EnemySpawnPath/EnemySpawnLocation
	# progress to a random point (this is the same as dodge the creeps)
	enemy_spawn_location.progress_ratio = randf()
	
	# perpendicular
	var direction = enemy_spawn_location.rotation + deg_to_rad(90)
	enemy.position = enemy_spawn_location.position

	# randomness in direction
	direction += randf_range(deg_to_rad(-45), deg_to_rad(45))
	enemy.rotation = direction
	
	var velocity = Vector2(randf_range(enemy_speed_min, enemy_speed_max), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	add_child(enemy)


func _on_enemy_spawn_timer_timeout():
	spawn_random_enemy()
	
