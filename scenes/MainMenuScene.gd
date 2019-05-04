extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var button_sp = $"PanelContainer/PanelContainer/MenuButton Container/Singleplayer"
onready var button_mp = $"PanelContainer/PanelContainer/MenuButton Container/Multiplayer"
onready var button_ht = $"PanelContainer/PanelContainer/MenuButton Container/How To Play"
onready var button_op = $"PanelContainer/PanelContainer/MenuButton Container/Options"
onready var button_qt = $"PanelContainer/PanelContainer/MenuButton Container/Quit"

onready var unimplemented = $PanelContainer/PanelContainer/Container/AcceptDialog

onready var buttons = [button_sp, button_mp, button_ht, button_op, button_qt]

func _ready():
	
	button_sp.connect("pressed",self,"singleplayer")
	button_mp.connect("pressed",self,"multiplayer")
	button_ht.connect("pressed",self,"how_to_play")
	button_op.connect("pressed",self,"options")
	button_qt.connect("pressed",self,"quit")
	
	pass

func disable_buttons():
	for b in buttons:
		b.disable()

func singleplayer():
	unimplemented.show()
	
func multiplayer():
	unimplemented.show()
	
func how_to_play():
	unimplemented.show()
	
func options():
	unimplemented.show()
	
func quit():
	disable_buttons()
	# Wait for sound to play
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().quit()
