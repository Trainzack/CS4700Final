extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.animation = get_parent().get_node("TileSprite").animation

#func _process(delta):
#	self.animation = get_parent().animation
