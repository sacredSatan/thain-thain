extends Node2D

@export var bunty_scene: PackedScene
@export var bablu_scene: PackedScene

# clean up later
@export var enemy_spawn_rate = 5
@export var enemy_speed_min = 150
@export var enemy_speed_max = 200

@export var operand_switch_rate = 8

var active_operand = 1


# Called when the node enters the scene tree for the first time.
func _ready():
#	spawn_random_enemy()
#	$EnemySpawnTimer.start(enemy_spawn_rate)
	$MainOperandSwitchTimer.start(operand_switch_rate)
	set_enemy_bullet_variant()


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


func get_preferred_enemy_bullet_variant():
	if $Player:
		var player_operator = $Player.active_operator

		if player_operator == Constants.SUPPORTED_OPERATORS.MULTIPLICATION:
			return Constants.BULLET_VARIANTS.MINUS
		elif player_operator == Constants.SUPPORTED_OPERATORS.DIVISION:
			return Constants.BULLET_VARIANTS.MINUS if active_operand == 1 else Constants.BULLET_VARIANTS.PLUS

	return Constants.BULLET_VARIANTS.MINUS
	

func set_enemy_bullet_variant():
	var enemy_bullet_variant = get_preferred_enemy_bullet_variant()
	get_tree().call_group("enemy", "handle_bullet_variant_change", enemy_bullet_variant)


func _on_enemy_spawn_timer_timeout():
	spawn_random_enemy()


func _on_main_operand_switch_timer_timeout():
	active_operand = 1 if active_operand != 1 else 2			
	get_tree().call_group("equation_holder", "handle_equation_operand_switch", active_operand)
	set_enemy_bullet_variant()
