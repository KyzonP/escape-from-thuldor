extends Node2D

@onready var player = get_parent().player

# Missile prefab preloaded
var misPre = preload("res://Prefabs/missile.tscn")
# Empty variable to become missile once instantiated
var mis

# Variables for locking on then firing
var locking = true
var lockTimer = 0
@export var lockTimerMax = 2.5

@export var speed = 100

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var rand = rng.randf_range(1,2)
	speed = speed * rand

func _physics_process(delta):
	if locking:
		if player.position.y < position.y:
			position.y -= speed * delta
		else:
			position.y += speed * delta
		
		#position.y = player.position.y
		
		lockTimer += delta
		if lockTimer >= lockTimerMax:
			spawnMissile()
			
			locking = false
			
			$Sprite.disableFlash()
		
func spawnMissile():
	mis = misPre.instantiate()
	mis.position.y = position.y
	mis.position.x = 600
	get_parent().add_child(mis)

func _on_area_entered(area):
	if area == mis:
		queue_free()
