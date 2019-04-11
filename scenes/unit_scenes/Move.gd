extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# The atom that this move uses
export(Vector2) var atom = null

# Whether this move can be used to reposition a unit
export(bool) var is_move = false

# Whether this move can be used to attack another unit
export(bool) var is_attack = false

# Whether this move repeats until stopped
export(bool) var rider = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
