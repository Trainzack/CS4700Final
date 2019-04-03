extends Area2D
export var tyle_type = "white"
export var highlight_type = "none"
onready var highlight = get_node("TileSprite").get_node("Highlight")

func set_tile_type(type):
	tyle_type = type
	$TileSprite.animation = tyle_type

func set_highlight(type):
	highlight_type = type
	highlight.animation = highlight_type
	highlight.play()

func deactivate():
	set_highlight("none")

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

#Will be changed to do something useful
func on_click():
	if highlight_type == "attack":
		set_highlight("movement")
	elif highlight_type == "movement":
		set_highlight("none")
	elif highlight_type == "none":
		set_highlight("attack")
	print("Click")
#func _process(delta):