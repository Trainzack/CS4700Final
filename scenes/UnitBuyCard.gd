extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var unit = null
onready var label = $VBoxContainer/Label
onready var textured = $VBoxContainer/CenterContainer/TextureRect
onready var price = $VBoxContainer/Price

var unit_scene = null
signal buy_pressed(scene, team)

func _ready():
	$VBoxContainer/WhiteBuy.connect("pressed", self, "bought",[0])
	$VBoxContainer/BlackBuy.connect("pressed", self, "bought",[1])
	pass


func set_unit(unit):
	price.text = str(unit.get_cost()) + " CC"
	label.text = unit.get_type().capitalize()
	textured.texture = unit.unit_sprite.frames.get_frame("white",0)
	
func set_scene(scene):
	unit_scene = scene
	
func bought(team):
	emit_signal("buy_pressed",unit_scene,team)