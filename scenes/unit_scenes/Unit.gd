extends Area2D
export var health = 0
var equipmentList = []
export var type = ""

#onready var highlight = get_node("UnitSprite").get_node("Highlight")
onready var selector_icon = $SelectorIcon

func _ready():
	pass

#func toggle_highlight():
#	if highlight.animation == "highlighted":
#		highlight.animation = "unhighlighted"
#	else:
#		highlight.animation = "highlighted"
func set_white():
	$UnitSprite.animation = "white"

func set_black():
	$UnitSprite.animation = "black"

func toggle_select():
	if $SelectorIcon.animation == "selected":
		$SelectorIcon.animation = "unselected"
	else:
		$SelectorIcon.animation = "selected"
	$SelectorIcon.play()

func print_info():
	print($UnitSprite.animation," ", type, " with health of ", health)