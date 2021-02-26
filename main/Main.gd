extends Node


export (PackedScene) var Coin
export (int) var playtime


var level
var score
var highscore = 0
var time_left
var screensize
var playing = false

const SAVE_FILE_PATH = "user://savedata.save"

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	$Control.hide()
	$Control2.hide()
	load_highscore()
	$HUD.show_highscore(Global.highscore)
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$Control.show()
	$Control2.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_coins():
	for i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(0,screensize.x), rand_range(0, screensize.y))
		$LevelSound.play()

func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()


func _on_GameTimer_timeout():
	time_left = time_left - 1
	$HUD.update_timer(time_left)
	if time_left == 0:
		game_over()


func game_over():
	if score > Global.highscore:
		highscore = score
		save_highscore()
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()
	$Control.hide()
	$Control2.hide()
	$EndSound.play()


func _on_Player_pickup():
	score += 1
	$HUD.update_score(score)
	$CoinSound.play()


func _on_Player_hurt():
	game_over()


func save_highscore():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(highscore)
	save_data.close()
	load_highscore()
	
func load_highscore():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		Global.highscore = save_data.get_var()
		save_data.close()
		
