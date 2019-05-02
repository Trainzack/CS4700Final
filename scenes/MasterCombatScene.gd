extends Node

var encounter_scene = preload("res://scenes/Encounter.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Knight.tscn")
var acting_side_units = []
var acting_unit_index = 0

func _ready():
	$TestBoard.connect("ally_unit_selected",self,"display_options")
	$TestBoard.connect("dummy_unit_selected",self,"hide_options")
	$TestBoard.connect("ally_has_moved",self,"disable_movement")
	$TestBoard.connect("ally_has_attacked",self,"disable_attacks")
	$UIManager.connect("attack_pressed",self,"display_attacks")
	$UIManager.connect("movement_pressed",self,"display_moves")
	$UIManager.connect("end_turn_pressed",self,"end_turn")
	$UIManager.connect("exit_combat",get_parent(),"end_combat")

func _process(delta):
	if Input.is_action_just_pressed("select_next_unit"):
		cycle_select_unit()

#Cycles through the acting army's units and selects them
func cycle_select_unit():
	$TestBoard.select_unit_by_object(acting_side_units[acting_unit_index])
	acting_unit_index += 1
	if acting_unit_index >= acting_side_units.size():
		acting_unit_index = 0

#generates the board's encounter.
#Also adds the inital acting side's units to our array
func set_encounter(encounter):
	$TestBoard.create_board(encounter)
	acting_side_units = $TestBoard.get_units_by_team($TestBoard.get_acting_team())
	
	#var pawn1 = pawn_scene.instance()
	#var pawn2 = pawn_scene.instance()
	#pawn1.set_black()
	#pawn2.set_black()
	#$TestBoard.switch_acting_team()
	#$UIManager.switch_turn_icon()
	#for i in range(0,8,2):
	#	for j in range(0,8,2):
	#		$TestBoard.place_unit(pawn_scene.instance(),i,j)
	#$TestBoard.place_unit(pawn1,0,1)
	#$TestBoard.place_unit(pawn2,4,6)
	#$TestBoard.select_ai_unit(pawn1)
	#$TestBoard.select_ai_unit(pawn1)

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

#End the turn resetting the moves of the units and states of the tiles
#Then tells the board to switch the acting side as well as the UI.
#Also updates the array of units for the upcoming acting side
func end_turn():
	hide_options()
	print("end turn reached")
	$UIManager.switch_turn_icon()
	$TestBoard.reset_unit_moves()
	$TestBoard.reset_tiles()
	$TestBoard.switch_acting_team()
	acting_side_units = $TestBoard.get_units_by_team($TestBoard.get_acting_team())