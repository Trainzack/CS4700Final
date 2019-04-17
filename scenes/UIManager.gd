extends Node
signal movement_pressed
signal attack_pressed
signal end_turn_pressed
onready var commands = $CommandContainer

func _ready():
	get_node("CommandContainer").get_node("MovementButton").connect("pressed",self,"emit_movement_pressed")
	get_node("CommandContainer").get_node("AttacksButton").connect("pressed",self,"emit_attack_pressed")
	get_node("EndTurnContainer").get_node("EndTurnButton").connect("pressed",self,"emit_end_turn_pressed")

func emit_movement_pressed():
	print("move button pressed")
	emit_signal("movement_pressed")

func emit_attack_pressed():
	print("attack button pressed")
	emit_signal("attack_pressed")

func emit_end_turn_pressed():
	emit_signal("end_turn_pressed")

func disable_movement():
	commands.get_node("MovementButton").disabled = true

func disable_attacks():
	commands.get_node("AttacksButton").disabled = true

func reset_command_states():
	commands.get_node("MovementButton").disabled = false
	commands.get_node("AttacksButton").disabled = false

func show_command_options():
	commands.visible = true

func hide_command_options():
	commands.visible = false