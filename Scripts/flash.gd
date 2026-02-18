extends Sprite2D

var flash = true
var flashTimer = 0.0
@export var flashTimerMax = 0.5

func _physics_process(delta):
	if flash:
		flashTimer += delta
		if flashTimer >= flashTimerMax:
			visible = !visible
			flashTimer = 0

func disableFlash():
	flash = false
	visible = true
