extends HSplitContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var button = $Button
onready var sprite = $Container/Sprite

func _ready():
	button.connect("mouse_entered",self,"select")
	button.connect("mouse_exited",self,"unselect")
	button.connect("pressed",self,"press")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func select():
	sprite.show()

func unselect():
	sprite.hide()
	
func press():
	pass