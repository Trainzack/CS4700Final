extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	$Area2D.connect("mouse_entered", self, "highlight")
	$Area2D.connect("mouse_exited", self, "unhighlight")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func highlight():
	scale = Vector2(1.5,1.5)

func unhighlight():
	scale = Vector2(1.0,1.0)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
