extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.animation = get_parent().animation
	print(self.animation)
	print(get_parent().animation)
	pass

#func _process(delta):
#	self.animation = get_parent().animation
