extends CanvasLayer


signal start_game

func update_score(value):
	$MarginContainer/Score/ScoreLabel.text = str(value)

func update_timer(value):
	$MarginContainer/Time/TimeLabel.text = str(value)


func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	$HighScoreLabel.hide()
	emit_signal("start_game")


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	
func show_game_over():
	show_message("Game Over")
	show_highscore(Global.highscore)
	yield($MessageTimer,"timeout")
	$StartButton.show()
	$MessageLabel.text = "Treasure Hunt"
	$MessageLabel.show()
	



func show_highscore(text):
	$HighScoreLabel.text = "BEST: " + str(text)
	$HighScoreLabel.show()
	
