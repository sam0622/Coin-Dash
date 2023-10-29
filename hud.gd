extends CanvasLayer


signal start_game 

func update_score(value): # Updates score
	$MarginContainer/Score.text = str(value)
	
func update_high_score(value):
	$HighScore.text = "High Score: " + str(value)
	
func show_high_score():
	$HighScore.show()
	
func update_timer(value): # Updates timer
	$MarginContainer/Time.text = str(value)

func show_message(text): # Allows you to show message
	$Message.text = text
	$Message.show()
	$Timer.start()
	
func _on_timer_timeout():
	$Message.hide()
	
func _on_start_button_pressed(): # When start is pressed it will hide the start button and title and tell the player.gd and main.gd files to start the game
	$StartButton.hide()
	$Message.hide()
	$HighScore.hide()
	start_game.emit()
	
func show_game_over():
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
	$HighScore.show()
	
