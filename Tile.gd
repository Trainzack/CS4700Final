extends AnimatedSprite

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func set_tile(type):
	self.animation = type

func set_outline(type):
	$Outline.animation = type

func set_cover(type):
	$Cover.animation = type

func deactivate():
	set_outline("none")
	set_cover("none")
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
