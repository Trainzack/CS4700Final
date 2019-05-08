extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var unit = null
onready var label = $Panel/VBoxContainer/Label
onready var textured = $Panel/VBoxContainer/CenterContainer/TextureRect
onready var price = $Panel/VBoxContainer/Price

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_unit(unit):
	#todo finish this shit