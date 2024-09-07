extends Node

@export var mob_scene: PackedScene  # The mob scene to instantiate during the game.
var score  # The player's score.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  

# This function is called when the player dies or the game ends.
func game_over() -> void:
	$ScoreTimer.stop()  # Stop the score timer since the game is over.
	$MobTimer.stop()  # Stop spawning new mobs.
	$HUD.show_game_over()  # Show the game over message.
	$Music.stop()  # Stop the background music.
	$DeathSound.play()  # Play the death sound when the player dies.

# This function starts a new game.
func new_game() -> void:
	$Music.play()  # Start playing the background music at the beginning of the game.
	
	score = 0  # Reset the score to 0.
	$Player.start($StartPosition.position)  # Move the player to the start position.
	
	# Update the score display and show the "Get Ready" message on the HUD.
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

	# Clear all mobs from the screen by calling `queue_free()` on all objects in the "mobs" group.
	get_tree().call_group("mobs", "queue_free")
	
	# Delay the start of the game by waiting for a few seconds before starting the mobs and score.
	# Will wait for 2 seconds before starting the creeps and the score timer.
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds.
	$HUD.show_message("")

	$MobTimer.start()  # Start spawning mobs at regular intervals.
	$ScoreTimer.start()  # Start the score timer to increment the score periodically.

# Called each time the score timer times out.
func _on_score_timer_timeout() -> void:
	score += 1  # Increment the score by 1.
	
	# Update the score display on the HUD to reflect the new score.
	$HUD.update_score(score)

# Called each time the mob timer times out to spawn a new mob.
func _on_mob_timer_timeout() -> void:
	# Create a new instance of the mob scene and add it to the main scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location along the Path2D to spawn the mob.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()  # Set the spawn location randomly along the path.
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to the chosen random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction in which the mob will move.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction  # Rotate the mob to face the chosen direction.

	# Choose the mob's speed and direction.
	var velocity = Vector2(randf_range(150.0, 250.0), 0)
	mob.linear_velocity = velocity.rotated(direction)  # Apply the velocity with the rotated direction.
	
	# Add the mob to the scene so it can appear and move.
	add_child(mob)
