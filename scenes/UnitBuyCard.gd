extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var unit = null
onready var label = $VBoxContainer/Label
onready var textured = $VBoxContainer/CenterContainer/TextureRect
onready var price = $VBoxContainer/Price

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func set_unit(unit):
	price.text = str(unit.get_cost()) + " CC"
	label.text = unit.get_type().capitalize()
	textured.texture = unit.unit_sprite.frames.get_frame("white",0)