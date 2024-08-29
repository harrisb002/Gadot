extends CanvasLayer

# Use signal to notify 'Main' that the button has been pressed
signal start_game
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	#Wait until the message timer has timed out
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	# Make a one shot timer and wait for it to finish
	# Await for the scene tree to finish
	await get_tree().create_timer(1.0).timeout
	
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
	
# Connecting to the HUD node from the StartButton
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

# Connecting to the HUD node from the MessageTimer
func _on_message_timer_timeout() -> void:
	pass # Replace with function body.
