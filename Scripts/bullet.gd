extends RigidBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var forceX = -50.0
@export var forceY = 10.0

func randomizeForces(x, y):
	forceX = forceX * x
	forceY = forceY * y

func _physics_process(delta):
	add_constant_force(Vector2(forceX,forceY))
	
	#position.y += velocity * delta
	#velocity = velocity - (slowDown * delta)
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Floor"):
		queue_free()
