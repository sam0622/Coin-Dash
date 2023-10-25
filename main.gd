extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var powerup_weight = 5
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready(): # Gets the screen size and hides player untill game start
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
func new_game(): # Changes some variables, starts the timer, initializes control, and spawns coins.
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
	
func spawn_coins(): # Logic for coin spawning. Higher level, more coins
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x),
			randi_range(0, screensize.y))
			
			
func _process(_delta): # If you get all the coins go to next level and add time
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.wait_time = randf_range(5, 8)
		$PowerupTimer.start()

func _on_game_timer_timeout(): # Game over if out of time
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt(): # End game if hit
	game_over()


func _on_player_pickup(type): # Manages pickups
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += powerup_weight
			$HUD.update_timer(time_left)
			
func game_over(): # Stop the game when you die
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()
	$Endsound.play()

func _on_hud_start_game(): # Starts the game when you press start
	new_game()

func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
