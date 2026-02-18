extends Area2D

@onready var game = get_parent()

@export var acceleration = 1

@export var reset = false

@export var spin = false

@export var spinSpeed = 45

var stopping = false
var stopTime = 100

var rng = RandomNumberGenerator.new()

func _ready():
	self.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.x -= Global.speed * acceleration * delta
	
	if spin:
		rotation_degrees += spinSpeed * delta
	
	if position.x < -400:
		if reset:
			reset_position()
		else:
			queue_free()
		
func reset_position():
	position.x = 400
	
	#Random Y between -150 and 150
	var y_position = rng.randf_range(-100.0, 100.0)
	position.y = y_position
	
	# Random rotation too
	var rot = rng.randi_range(1,8)
	rotation_degrees = rot * 45
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		if game != null:
			game.endGame()
			
func windDown():
	stopping = true
