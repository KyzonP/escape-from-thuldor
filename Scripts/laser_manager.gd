extends Node2D

var lasPre = preload("res://Prefabs/laser.tscn")

var lasers = []

var timer = 0

var rng = RandomNumberGenerator.new()

@export var timerMax1 = 3
@export var timerMax2 = 6

func _ready():
	beginLasers()
	assignLasers()
	
func _physics_process(delta):
	if timer < 8:
		timer += delta
		if timer >= 7:
			removeLasers()
			updateGameManager()
			
			# Really bad way of making sure these dont trigger multiple times
			timer = 9

func beginLasers():
	#-135, 45
	# Summon all 7 lasers - each 45 px apart on the y axis. 
	var startY = -135
	for i in 7:
		summonLaser(startY)
		startY = startY + 45

func summonLaser(posY):
	var las = lasPre.instantiate()
	las.position.y = posY
	las.position.x = 0
	
	add_child(las)
	lasers.append(las)
		
func assignLasers():
	rng.randomize()
	var middle = rng.randi_range(0,6)
	
	for i in lasers:
		i.timerMax = timerMax1
		i.timerWarning = i.timerMax - 1.5
		i.timerEnd = i.timerMax + 1
	
	lasers[middle-1].timerMax = timerMax2
	lasers[middle].timerMax = timerMax2
	if middle != 6:
		lasers[middle+1].timerMax = timerMax2
	else:
		lasers[0].timerMax = timerMax2
	
	for i in lasers:
		i.timerWarning = i.timerMax - 1.5
		i.timerEnd = i.timerMax + 1
	
func removeLasers():
	for i in lasers:
		i.endLaser()
		
func updateGameManager():
	get_parent().laserOver()
	
	
