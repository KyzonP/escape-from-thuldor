extends Node2D

@onready var orb1 = get_node("Orb1")
@onready var orb2 = get_node("Orb2")

var glow = false
@onready var glow1 = get_node("Orb1/Glow1")
@onready var glow2 = get_node("Orb2/Glow2")

@export var rotateSpeed = 50
@export var glowSpeed = 1

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	setUp()

func _physics_process(delta):
	orb1.rotation_degrees += rotateSpeed * delta
	orb2.rotation_degrees -= rotateSpeed * delta
	
	#glow1.self_modulate.a += glowSpeed * delta
	#glow2.self_modulate.a -= glowSpeed * delta
	if glow:
		glow1.self_modulate.a += glowSpeed * delta
		glow2.self_modulate.a += glowSpeed * delta
		#glow1.self_module.a += glowSpeed * delta
		#glow2.self_module.a += glowSpeed * delta
		if glow2.self_modulate.a >= 1:
			glow = false
		pass
	else:
		glow1.self_modulate.a -= glowSpeed * delta
		glow2.self_modulate.a -= glowSpeed * delta
		#glow1.self_module.a -= glowSpeed * delta
		#glow2.self_module.a -= glowSpeed * delta
		if glow2.self_modulate.a <= 0:
			glow = true
		pass
	
func setUp():
	var randI = rng.randi_range(rotateSpeed/2, rotateSpeed * 2)
	rotateSpeed = randI
	
	if (randI%2 == 0):
		glow = true
	else:
		glow = false
		
	var randF = rng.randf_range(0,1)
	glow1.self_modulate.a = randF
	glow2.self_modulate.a = randF
