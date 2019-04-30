extends Node
signal movement_pressed
signal attack_pressed
signal end_turn_pressed
signal exit_combat
onready var commands = $CommandContainer

var unit_selected = false
# TODO: Make sure we don't send movement pressed or attack pressed signals if not unit is selected

onready var end_turn_sound = $EndTurnSound
onready var select_attack_sound = $SelectAttackSound
onready var select_move_sound = $SelectMoveSound

# Whether the currently 
var can_attack = false
var can_move = false

func _ready():
	get_node("CommandContainer").get_node("MovementButton").connect("pressed",self,"emit_movement_pressed")
	get_node("CommandContainer").get_node("AttacksButton").connect("pressed",self,"emit_attack_pressed")
	get_node("EndTurnContainer").get_node("EndTurnButton").connect("pressed",self,"emit_end_turn_pressed")
	get_node("ExitCombatContainer/ExitCombatButton").connect("pressed",self,"emit_exit_combat")

func _process(delta):
	if Input.is_action_just_pressed("select_move") and commands.get_node("MovementButton").disabled == false:
		emit_movement_pressed()
	if Input.is_action_just_pressed("select_attack") and commands.get_node("AttacksButton").disabled == false:
		emit_attack_pressed()
	if Input.is_action_just_pressed("end_turn"):
		emit_end_turn_pressed()

func emit_movement_pressed():
	#print("move button pressed")
	select_move_sound.play()
	emit_signal("movement_pressed")

func emit_attack_pressed():
	#print("attack button pressed")
	select_attack_sound.play()
	emit_signal("attack_pressed")

func emit_exit_combat():
	emit_signal("exit_combat")

func emit_end_turn_pressed():
	emit_signal("end_turn_pressed")
	end_turn_sound.play()

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