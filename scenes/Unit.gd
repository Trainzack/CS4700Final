extends Area2D
export var health = 0

onready var highlight = get_node("UnitSprite").get_node("Highlight")
onready var selector_icon = get_node("UnitSprite").get_node("SelectorIcon")

func _ready():
	toggle_select()
	pass

func toggle_highlight():
	if highlight.animation == "highlighted":
		highlight.animation = "unhighlighted"
	else:
		highlight.animation = "highlighted"

func toggle_select():
	if selector_icon.animation == "selected":
		selector_icon.animation = "unselected"
	else:
		selector_icon.animation = "selected"
	selector_icon.play()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
