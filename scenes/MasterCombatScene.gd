extends Node

var encounter_scene = preload("res://scenes/Encounter.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Knight.tscn")
var acting_side_units = []
var acting_unit_index = 0
onready var board = $TestBoard
onready var ui_manager = $UIManager

func _ready():
	board.connect("ally_unit_selected",self,"on_unit_selected")
	board.connect("dummy_unit_selected",self,"hide_options")
	board.connect("ally_has_moved",self,"disable_movement")
	board.connect("ally_has_attacked",self,"disable_attacks")
	ui_manager.connect("attack_pressed",self,"display_attacks")
	ui_manager.connect("movement_pressed",self,"display_moves")
	ui_manager.connect("end_turn_pressed",self,"end_turn")
	ui_manager.connect("exit_combat",get_parent(),"end_combat")

func _process(delta):
	if Input.is_action_just_pressed("select_next_unit"):
		cycle_select_unit()

#Cycles through the acting army's units and selects them
func cycle_select_unit():
	var loop_tracker = 0
	var unit_selected = false
	var unit_to_consider = acting_side_units[acting_unit_index]
	while (loop_tracker < acting_side_units.size()) and (unit_selected == false):
		if(unit_to_consider.has_attacked == false or unit_to_consider.has_moved == false):
			board.select_unit_by_object(unit_to_consider)
			unit_selected = true
			break
		acting_unit_index = (acting_unit_index + 1) % acting_side_units.size()
		unit_to_consider = acting_side_units[acting_unit_index]
		loop_tracker += 1

#sets the acting_unit_index to the next index in the unit array
func set_cycle_index_to_selected(unit):
	for i in range(0,acting_side_units.size()):
		if unit == acting_side_units[i]:
			acting_unit_index = (i + 1) % acting_side_units.size()

#generates the board's encounter.
#Also adds the inital acting side's units to our array
func set_encounter(encounter):
	board.create_board(encounter)
	acting_side_units = board.get_units_by_team(board.get_acting_team())
	set_acting_units()

func on_unit_selected(unit):
	ui_manager.show_unit_info(unit)
	display_options()
	set_cycle_index_to_selected(unit)

func display_options():
	ui_manager.reset_command_states()
	ui_manager.show_command_options()

func hide_options():
	ui_manager.hide_unit_info()
	ui_manager.reset_command_states()
	ui_manager.hide_command_options()

func disable_attacks():
	ui_manager.disable_attacks()

func disable_movement():
	ui_manager.disable_movement()

func display_attacks():
	board.show_attack_options()

func display_moves():
	board.show_movement_options()

func set_acting_units():
	for unit in acting_side_units:
		unit.toggle_acting()
		unit.display_action_icons_passive()

func unset_acting_units():
	for unit in acting_side_units:
		unit.hide_action_icons()

#End the turn resetting the moves of the units and states of the tiles
#Then tells the board to switch the acting side as well as the UI.
#Also updates the array of units for the upcoming acting side
func end_turn():
	hide_options()
	print("end turn reached")
	ui_manager.switch_turn_icon()
	board.reset_unit_moves()
	board.reset_tiles()
	unset_acting_units()
	board.switch_acting_team()
	acting_side_units = board.get_units_by_team(board.get_acting_team())
	set_acting_units()
	acting_unit_index = 0