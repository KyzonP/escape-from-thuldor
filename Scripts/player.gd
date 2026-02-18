extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bullet = preload("res://Prefabs/bullet.tscn")

@onready var anim = $AnimatedSprite2D

var jump_speed = -35.0

var flying = false

var freeze = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _input(event):
	if !freeze:
		if event.is_action_pressed("Fly"):
			Fly()
		elif event.is_action_released("Fly"):
			Release()
	
func _physics_process(delta):
	# Gravity affecting
	velocity.y += gravity * delta
	
	# If flying is toggled, go up
	if flying:
		if anim.animation != "Fly":
			anim.animation = "Fly"
		
		# Spawn bullet
		spawnBullet()
		
		velocity.y += jump_speed
		
		# Capping upwards momentum
		if velocity.y < -gravity:
			velocity.y = -gravity
	
	# Making physics happen
	move_and_slide()
	
func spawnBullet():
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.global_position = self.global_position + Vector2(-7,15)
	
	var randX = rng.randf_range(0.1,1.9)
	var randY = rng.randf_range(0.1, 1.9)
	bullet.randomizeForces(randX, randY)

func Fly():
	flying = true
	anim.play("Fly")
	
	$Jetboot.playing = true
	
func Release():
	flying = false
	anim.play("Fall")
	
	$Jetboot.playing = false

func ResetPos():
	PhysicsServer2D.body_set_state(
	get_rid(),
	PhysicsServer2D.BODY_STATE_TRANSFORM,
	Transform2D.IDENTITY.translated(Vector2(-100.0, 0.0))
	)
	
func explode():
	$Boom.play()
	anim.visible = false
	anim.play("Fly")
	for i in 25:
		var bullet = bullet.instantiate()
		add_child(bullet)
		bullet.global_position = self.global_position
		
		var randX = rng.randf_range(-1.9,1.9)
		var randY = rng.randf_range(-1.9,1.9)
		bullet.randomizeForces(randX, randY)

func _on_floor_check_area_entered(area):
	if anim.visible:
		anim.play("Run")


func _on_animated_sprite_2d_frame_changed():
	if anim.animation == "Run":
		if anim.frame == 0 or anim.frame == 3:
			$Footstep.play()
