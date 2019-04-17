extends Node

func _ready():
	$TestBoard.connect("ally_unit_selected",self,"display_options")
	$TestBoard.connect("dummy_unit_selected",self,"hide_options")
	$TestBoard.connect("ally_has_moved",self,"disable_movement")
	$TestBoard.connect("ally_has_attacked",self,"disable_attacks")
	$UIManager.connect("attack_pressed",self,"display_attacks")
	$UIManager.connect("movement_pressed",self,"display_moves")
	$UIManager.connect("end_turn_pressed",self,"end_turn")

func display_options():
	$UIManager.reset_command_states()
	$UIManager.show_command_options()

func hide_options():
	$UIManager.reset_command_states()
	$UIManager.hide_command_options()

func disable_attacks():
	$UIManager.disable_attacks()

func disable_movement():
	$UIManager.disable_movement()

func display_attacks():
	$TestBoard.show_attack_options()

func display_moves():
	$TestBoard.show_movement_options()

func end_turn():
	hide_options()
	print("end turn reached")
	$TestBoard.reset_unit_moves()
	$TestBoard.reset_tiles()
