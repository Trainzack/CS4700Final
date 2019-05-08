extends Node

var encounter_scene = preload("res://scenes/Encounter.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Knight.tscn")
var acting_side_units = []
var acting_unit_index = 0
onready var board = $TestBoard
onready var ui_manager = $UIManager
onready var second_timer = $SecondTimer
onready var turn_time_label = $TurnTimer/TimerValue
onready var wait_for_damage_timer = $WaitForDamageTimer
onready var meep_merp = $DeniedSound
var allotted_turn_time = 35
var turn_time_left = allotted_turn_time
var timed_game = false

func _ready():
	#set_timed_game(60)
	board.connect("ally_unit_selected",self,"on_unit_selected")
	board.connect("dummy_unit_selected",self,"hide_options")
	board.connect("ally_has_moved",self,"disable_movement")
	board.connect("ally_has_attacked",self,"disable_attacks")
	board.connect("ally_has_attacked",self,"check_win_condition")
	board.connect("nothing_highlighted",self,"play_meep_merp")
	ui_manager.connect("attack_pressed",self,"display_attacks")
	ui_manager.connect("movement_pressed",self,"display_moves")
	ui_manager.connect("end_turn_pressed",self,"end_turn")
	ui_manager.connect("exit_combat",get_parent(),"exit_scene")

func set_allotted_turn_time(time):
	allotted_turn_time = time
	turn_time_left = allotted_turn_time

func set_timed_game(time = 30):
	set_allotted_turn_time(time)
	timed_game = true
	second_timer.connect("timeout",self,"countdown_turn_time")
	second_timer.start()
	turn_time_label.text = format_turn_time(allotted_turn_time)
	$TurnTimer.show()

func countdown_turn_time():
	turn_time_left -= 1
	turn_time_label.text = format_turn_time(turn_time_left)
	if(turn_time_left <= 0):
		turn_time_left = allotted_turn_time
		turn_time_label.text = format_turn_time(turn_time_left)
		$EndTurnSound.play()
		end_turn()

func format_turn_time(time):
	var formatted = "%02d"
	return formatted % [time]

func _process(delta):
	if Input.is_action_just_pressed("select_next_unit"):
		cycle_select_unit()

#Cycles through the acting army's units and selects one
#Skips over units that don't have actions
#If none have any actions left, none are selected
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
	if loop_tracker == acting_side_units.size():
		meep_merp.play()

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
	if timed_game:
		turn_time_left = allotted_turn_time
		turn_time_label.text = format_turn_time(turn_time_left)
	#check_win_condition()

func play_meep_merp():
	meep_merp.play()
	

func disconnect_combat_signals():
	board.disconnect("ally_unit_selected",self,"on_unit_selected")
	board.disconnect("dummy_unit_selected",self,"hide_options")
	board.disconnect("ally_has_moved",self,"disable_movement")
	board.disconnect("ally_has_attacked",self,"disable_attacks")
	board.disconnect("nothing_highlighted",self,"play_meep_merp")
	ui_manager.disconnect("attack_pressed",self,"display_attacks")
	ui_manager.disconnect("movement_pressed",self,"display_moves")
	ui_manager.disconnect("end_turn_pressed",self,"end_turn")
	#ui_manager.disconnect("exit_combat",get_parent(),"end_combat")

func check_win_condition():
	wait_for_damage_timer.start()
	yield(wait_for_damage_timer,"timeout")
	print("win condition checked")
	var white_side = board.get_units_by_team(0)
	var black_side = board.get_units_by_team(1)
	print("black_side size is " + str(black_side.size()))
	print("white_side size is " + str(white_side.size()))
	if white_side.size() == 0 or black_side.size() == 0:
		end_combat()

func end_combat():
	$Music.stop()
	ui_manager.disable_ui()
	board.disconnect_board()
	disconnect_combat_signals()
	if timed_game:
		second_timer.stop()
	if board.get_acting_team() == 1:
		ui_manager.display_black_victory()
	elif board.get_acting_team() == 0:
			ui_manager.display_white_victory()