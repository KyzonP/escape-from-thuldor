extends Node2D

@onready var scoreText = $Score
@onready var highScoreText = $HighScore
@onready var gameOverText = $GameOver
@onready var newRecordText = $NewRecord
@onready var restartText = $Restart
var score = 0
var highScore = 0

var playerPrefab = preload("res://Prefabs/player.tscn")
@onready var player = $Player
var active = true

### First orbs, then missiles, then orbs can spin, then laser? If laser, wait at least 9 seconds. ###     
var lasPre = preload("res://Prefabs/laser_manager.tscn")
var orbPre = preload("res://Prefabs/orbs.tscn")
var misPre = preload("res://Prefabs/missile_warning.tscn")
var obstacleTimer = 3
var obstacleTimerMax = 3
var laserActive = false
# really bad method for determining multiple orbs!
var repeatOrb = false

# RNG
var rng = RandomNumberGenerator.new()

# Orb has to reset position at first
# Laser pauses timer, but when done instantly begins next obstacle

### DEATH RESET TIMER ###
var deathResetTimer = 0
@export var deathResetTimerMax = 1.5


func _ready():
	load_data()
	
	updateScore(true)
	
func laserOver():
	laserActive = false
	obstacleTimer = obstacleTimerMax
	
	if obstacleTimerMax > 1.5:
		obstacleTimerMax -= 0.05

func _physics_process(delta):
	if active:
		score += delta
		updateScore(false)
		
		### Obstacle stuff ###
		#if !laserActive:
			#obstacleTimer += delta
			#if obstacleTimer >= obstacleTimerMax:
				#_calculateObstacle()
				#obstacleTimer = 0
			#elif obstacleTimer >= (obstacleTimerMax/2) and repeatOrb:
				#summonOrb(false)
				#repeatOrb = false
		obstacleTimer += delta
		if obstacleTimer >= obstacleTimerMax:
			_calculateObstacle()
			obstacleTimer = 0
		elif obstacleTimer >= (obstacleTimerMax/2) and repeatOrb:
			summonOrb(false)
			repeatOrb = false
			
	else:
		deathResetTimer += delta
		if deathResetTimer >= deathResetTimerMax and restartText.visible == false:
			restartText.visible = true
		
func _input(event):
	if !active && deathResetTimer >= deathResetTimerMax:
		if event.is_action_released("Restart"):
			restartGame()
		
func restartGame():
	### Reset gameplay elements
	active = true
	deathResetTimer = 0
	
	player.queue_free()
	var playerTemp = playerPrefab.instantiate()
	playerTemp.global_position = Vector2(-100,0)
	add_child(playerTemp)
	player = playerTemp
	
	
	#player.freeze = false
	#player.anim.visible = true
	#player.ResetPos()
	
	#player.Release()
	
	for i in get_children():
		if i.is_in_group("DestroyOnReset"):
			i.queue_free()
			
	score = 0
	
	# Restart background
	$"FloorRoof-1".restart()
	$"FloorRoof-2".restart()
	
	### Hide Game Over UI ###
	gameOverText.visible = false
	newRecordText.visible = false
	restartText.visible = false
	

func endGame():
	if active:
		### Freeze gameplay elements
		active = false
		player.freeze = true
		player.explode()
		
		player.Release()
		
		for i in get_children():
			if i.is_in_group("Obstacle"):
				i.windDown()
		
		### Update score and UI ###
		gameOverText.text = "[center]Game Over! Score: " + str(int(round(score*10))) + "m[/center]"
		gameOverText.visible = true
		
		if score > highScore:
			highScore = score
			updateScore(true)
			
			save_game()
			
			newRecordText.visible = true
		
		
func updateScore(newHighScore):
	scoreText.text = str(int(round(score*10))) + "m"
	if newHighScore:
		highScoreText.text = "Record: " + str(int(round(highScore*10))) + "m"
		
func _calculateObstacle():
	# 100, 200, 300?
	if score <= 15:
		summonOrb(false)
	elif score <= 30:
		var obs = rng.randi_range(0,2)
		if obs == 0:
			summonOrb(false)
		else:
			summonMissile()
	elif score <= 45:
		var obs = rng.randi_range(0,4)
		if obs < 2:
			if obs == 0:
				summonOrb(true)
			else:
				summonOrb(false)
		else:
			summonMissile()
	elif !laserActive:
		var obs = rng.randi_range(0,5)
		if obs < 2:
			if obs == 0:
				summonOrb(true)
			else:
				summonOrb(false)
		elif obs < 4:
			summonMissile()
		else:
			summonLaser()
	else:
		var obs = rng.randi_range(0,4)
		if obs < 2:
			summonOrb(true)
		else:
			summonMissile()
	
func summonOrb(rot):
	var orb = orbPre.instantiate()
	orb.reset_position()
	add_child(orb)
	
	if rot:
		orb.spin = true
		
	if !repeatOrb:
		repeatOrb = true
	
func summonLaser():
	var las = lasPre.instantiate()
	add_child(las)
	laserActive = true
	
func summonMissile():
	var obs = rng.randi_range(0, 3)
	
	for i in obs:
		var mis = misPre.instantiate()
		mis.position.x = 300
		add_child(mis)
		mis.lockTimerMax += (float(i)/2)

##### SAVE FUNCTIONS #####
func save():
	var save_dict = {
		"highScore": highScore
	}
	return save_dict
	
func save_game():
	var save_game = FileAccess.open("user://citadelSearch.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)
	
func load_data():
	if not FileAccess.file_exists("user://citadelSearch.save"):
		return
	
	var save_game = FileAccess.open("user://citadelSearch.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json=JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		for i in node_data.keys():
			if i=="highScore":
				highScore = node_data[i]
		
