extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var button = $Button
onready var sprite = $Container/Sprite
onready var sound_hover = $HoverSound
onready var sound_begin = $BeginClick
onready var sound_confirm = Global.sound_confirm

export var button_text = "Button"
export(Texture) var button_sprite = null
export var strong_sound = true

signal pressed

func _ready():
	button.connect("mouse_entered",self,"select")
	button.connect("mouse_exited",self,"unselect")
	button.connect("button_down",self,"begin_press")
	button.connect("button_up",self,"press")
	button.text = button_text
	sprite.texture = button_sprite
	if not strong_sound:
		sound_confirm = $WeakConfirm

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func select():
	if not button.disabled:
		sprite.show()
		sound_hover.play()
	

func unselect():
	sprite.hide()
	
func begin_press():
	sound_confirm.play()
	emit_signal("pressed")
	
func press():
	pass
	
func enable():
	button.disabled = false
	
func disable():
	button.disabled = true
	sprite.hide()