extends Area2D

@onready var game = get_tree().get_root().get_node("Game")
@onready var anim = get_node("Laser")

@onready var leftOrb = $LeftOrb
@onready var rightOrb = $RightOrb
var orbSpeed = 15

var timer = 0
var timerWarning
var timerMax
var timerEnd

var active = false

var group = 0

var laserEnding = false
	
func _physics_process(delta):
	### Orb Arrival ###
	if !laserEnding:
		if leftOrb.position.x < -310:
			leftOrb.position.x += orbSpeed * delta
		elif leftOrb.position.x > -310:
			leftOrb.position.x = -310
			
		if rightOrb.position.x > 310:
			rightOrb.position.x -= orbSpeed * delta
		elif rightOrb.position.x < 310:
			rightOrb.position.x = 310
			
		### Laser Mechanics ###
		timer += delta
		
		if timer >= timerWarning and timer < timerMax:
			anim.play("warning")
			$CollisionShape2D.disabled = false
		elif timer >= timerMax and timer < timerEnd:
			anim.play("active")
			active = true
			$CollisionShape2D.debug_color = Color(0.757, 0.0, 0.0, 1.0)
		elif timer >= timerEnd:
			active = false
			anim.play("inactive")
			$CollisionShape2D.disabled = true
		elif timer >= 7.0 and !laserEnding:
			endLaser()
		
	if laserEnding:
		print("hmm")
		leftOrb.position.x -= orbSpeed * delta
			
		rightOrb.position.x += orbSpeed * delta
		if rightOrb.position.x >= 330:
			get_parent().queue_free()
			queue_free()
	
func endLaser():
	laserEnding = true
	active = false
	anim.play("inactive")
	$CollisionShape2D.disabled = true

func _on_body_entered(body):
	if active:
		if body.is_in_group("Player"):
			if game != null:
				game.endGame()
