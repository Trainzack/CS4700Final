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
onready var turn_icon_container = $WhoseTurnContainer
onready var turn_icon = get_node("WhoseTurnContainer").get_node("TurnIcon")
onready var unit_info = $UIUnitInformation

# Whether the currently 
var can_attack = false
var can_move = false

func _ready():
	get_node("CommandContainer").get_node("MovementButton").connect("pressed",self,"emit_movement_pressed")
	get_node("CommandContainer").get_node("AttacksButton").connect("pressed",self,"emit_attack_pressed")
	get_node("EndTurnContainer").get_node("EndTurnButton").connect("pressed",self,"emit_end_turn_pressed")
	get_node("ExitCombatContainer2/ExitCombatButton").connect("pressed",self,"emit_exit_combat")
	unit_info.hide()

#_process is used to wait for user input from the keyboard
func _process(delta):
	if Input.is_action_just_pressed("select_move") and commands.get_node("MovementButton").disabled == false and commands.visible == true:
		emit_movement_pressed()
	if Input.is_action_just_pressed("select_attack") and commands.get_node("AttacksButton").disabled == false and commands.visible == true:
		emit_attack_pressed()
	if Input.is_action_just_pressed("end_turn"):
		print("yeet")
		emit_end_turn_pressed()

#emit functions propogate signals when the corresponding buttons are pressed
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

#disables movement button
func disable_movement():
	commands.get_node("MovementButton").disabled = true

#disables attack button
func disable_attacks():
	commands.get_node("AttacksButton").disabled = true

func reset_command_states():
	commands.get_node("MovementButton").disabled = false
	commands.get_node("AttacksButton").disabled = false

func show_command_options():
	commands.visible = true

func hide_command_options():
	commands.visible = false

func show_unit_info(unit):
	unit_info.show_information(unit)

func hide_unit_info():
	unit_info.hide()

#Plays the animation for making the turn icon switch to the other side
#Once the animation ends it stays displaying either "black's turn" or "white's turn"
func switch_turn_icon():
	if turn_icon.animation == "white_turn":
		turn_icon.play("black_turn_transition")
		yield(turn_icon,"animation_finished")
		turn_icon.animation = "black_turn"
	else:
		turn_icon.play("white_turn_transition")
		yield(turn_icon,"animation_finished")
		turn_icon.animation = "white_turn"