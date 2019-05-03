extends Node

var encounter_scene = preload("res://scenes/Encounter.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Knight.tscn")
var acting_side_units = []
var acting_unit_index = 0
onready var board = $TestBoard
onready var ui_manager = $UIManager

func _ready():
	board.connect("ally_unit_selected",self,"display_options")
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
	board.select_unit_by_object(acting_side_units[acting_unit_index])
	acting_unit_index = (acting_unit_index + 1) % acting_side_units.size()

#generates the board's encounter.
#Also adds the inital acting side's units to our array
func set_encounter(encounter):
	$TestBoard.create_board(encounter)
	acting_side_units = $TestBoard.get_units_by_team($TestBoard.get_acting_team())
	
	var pawn1 = pawn_scene.instance()
	#var pawn2 = pawn_scene.instance()
	pawn1.set_white()
	#pawn2.set_black()
	#$TestBoard.switch_acting_team()
	#$UIManager.switch_turn_icon()
	#for i in range(0,8,2):
	#	for j in range(0,8,2):
	#		$TestBoard.place_unit(pawn_scene.instance(),i,j)
	$TestBoard.place_unit(pawn1,0,1)
	var pawn2 = pawn1.duplicate(DUPLICATE_USE_INSTANCING)
	add_child(pawn2)
	pawn2.position = Vector2(50,500)
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