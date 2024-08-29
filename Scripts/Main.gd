extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	# Update the score display and show the "Get Ready" message
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# Get the mobs group so remove all mobs from the screen collectively
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	
	# Keep the display in sync with the changing score
	$HUD.update_score(score)

# When this times out it will process this
func _on_mob_timer_timeout() -> void:
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity (speed & direction) for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the main scene
	add_child(mob)
