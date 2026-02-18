extends Node2D

@export var endPos = 0
@export var startPos = 0
@export var travelTime = 0.0

var totalDistance

# Calculating which background set piece this is - don't know why I'm doing 
# this instead of just like, setting a public bool
var node_name
var backgroundSide = 0

# Flag for if the background should be moving
var active = true

func _ready():
	totalDistance = abs(endPos) + abs(startPos)
	
	_calculateSide()
	
func _calculateSide():
	node_name = get_name()
	var node_name_split = node_name.split("-", true, 1)
	backgroundSide = int(node_name_split[1])

func _physics_process(delta):
	if active:
		position.x -= Global.speed * delta
		
		if position.x <= endPos:
			position.x = startPos

func pause():
	active = false
	
func restart():
	if backgroundSide == 1:
		position.x = 0
	elif backgroundSide == 2:
		position.x = 640
	
	active = true
