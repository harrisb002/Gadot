extends CanvasLayer

# Signal to notify 'Main' that the button has been pressed
signal start_game

# Called when the scene is ready
func _ready() -> void:
	# Show the initial message "Dodge the Creeps!" and the start button
	show_message("Dodge the Creeps!")
	$StartButton.show()  # Display the start button at the beginning

# Function to display messages like "Game Over" or "Dodge the Creeps!"
func show_message(text: String) -> void:
	$Message.text = text  # Set the text for the message label
	$Message.show()  # Show the message
	$MessageTimer.start()  # Start a timer to hide the message after a short delay

# Function to show the "Game Over" message, followed by "Dodge the Creeps!"
func show_game_over() -> void:
	show_message("Game Over")  # Show the game over message

	# Wait for the message timer to time out
	await $MessageTimer.timeout
	
	# Change the message to "Dodge the Creeps!" and display it
	$Message.text = "Dodge the Creeps!"
	$Message.show()

	# Create a one-shot timer to wait for 1 second before showing the Start button
	await get_tree().create_timer(1.0).timeout

	# Show the Start button again for the player to restart the game
	$StartButton.show()

# Update the score on the HUD
func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)  # Convert the score to a string and update the score label

# Handle the Start button press event
func _on_start_button_pressed() -> void:
	$StartButton.hide()  # Hide the start button when pressed
	$Message.hide()  # Hide any messages when the game starts
	start_game.emit()  # Emit the signal to notify 'Main' that the game has started
