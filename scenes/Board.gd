extends Node

var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var tile_scene = preload("res://scenes/Tile.tscn")
var water_tile_scene = preload("res://scenes/WaterTile.tscn")
var wall_tile_scene = preload("res://scenes/WallTile.tscn")

var encounter_scene = preload("res://scenes/Encounter.tscn")
onready var meep_merp = $DeniedSound

#offsets used to populate the board. Values come from testing different positions
var starting_x = 300
var starting_y = 400
var iso_x_offset = 83*0.7
var iso_y_offset = 63*0.7
var y3D_offset = -36*0.7
var boardArray = []
var unitArray = []

var acting_team = 0

var board_x_size = 8
var board_y_size = 8

var dummy_unit = unit_scene.instance()
var selected_unit = dummy_unit
var selected_unit_coordinate = Vector2(-1,-1)

# keep track of whether this board has been created already
var board_ready = false

signal ally_unit_selected(unit)
signal dummy_unit_selected
signal ally_has_moved
signal ally_has_attacked

func _ready():
	add_child(dummy_unit)

func get_acting_team():
	return acting_team

func get_tile(position):
	return boardArray[position.x][position.y]

#Returns the unit at a given position
func get_unit(position):
	return unitArray[position.x][position.y]

func get_unit_by_object(unit):
	for i in range(board_x_size):
		for j in range(board_y_size):
			if unit == unitArray[i][j]:
				return unit

#Returns an array of the alive units on the board that are on a team
#Can never return an abstract unit because they don't have a team value
func get_units_by_team(team):
	var desired_units_list = []
	for i in range(0,8):
		for j in range(0,8):
			if unitArray[i][j].get_team() == team and not unitArray[i][j].is_dead():
				desired_units_list.append(unitArray[i][j])
	return desired_units_list

# Internal method for placing a particular tile in a particular place
func place_tile(position, tile):
	if not position_in_bounds(position):
		printerr("invalid tile position: " + position)
	else:
		# TODO: Remove the tile that's already here
		add_child(tile)
		# print(position)
		if int(position.x)%2 == int(position.y)%2:
			tile.set_tile_type("white")
		else:
			tile.set_tile_type("black")
		tile.position = Vector2(starting_x + position.x*iso_x_offset + position.y*iso_x_offset, starting_y - position.y*iso_y_offset + position.x*iso_y_offset)
		tile.z_index = tile.z_index - position.y*2 + position.x*3
		tile.connect("mouse_entered", self, "process_mouse_enter", [position.x,position.y])
		tile.connect("mouse_exited", self, "process_mouse_exit", [position.x,position.y])
		tile.connect("clicked", self, "on_click", [position.x,position.y])
		boardArray[position.x][position.y] = tile

#Positions the tiles of the board onto the screen
#Also fills up the boardArray with tileArrays, creating a 2d array of tiles
#Tiles occupy z indeces 0-10
#Generates the board based on an encounter object thats passed in
func create_board(encounter):
	if board_ready:
		printerr("Board already setup!")
	else:
	# Create the 2D array that holds the tiles, and the array that holds the units
		for x in range(board_x_size):
			var tileArray = []
			var tempUnitArray = []
			for y in range(board_y_size):
				tileArray.append(null)
				tempUnitArray.append(dummy_unit)
			boardArray.append(tileArray)
			unitArray.append(tempUnitArray)
			
		encounter.build_board(self)
		board_ready = true
	

#For initally placing a unit on the board
func place_unit(placed_unit, gridX, gridY):
	if(!boardArray[gridX][gridY].is_occupied()):
		boardArray[gridX][gridY].set_occupied(true)
		placed_unit.position = boardArray[gridX][gridY].get_placement_position().get_global_transform().get_origin()
		placed_unit.z_index = 2 + boardArray[gridX][gridY].z_index
		add_child(placed_unit)
		unitArray[gridX][gridY] = placed_unit
	else:
		printerr("Tile is occupado")

#Deselects the previously selected unit and activates a different one.
func on_click(gridX,gridY):
	var currently_clicked_tile = boardArray[gridX][gridY]
	
	#If the tile you clicked can be moved to, move to it
	if selected_unit.get_type() != "abstract_unit" and currently_clicked_tile.can_move_to:
		print("moved unit")
		move_unit(selected_unit_coordinate.x,selected_unit_coordinate.y,gridX,gridY)
		selected_unit.update_selection_icon()
		reset_tiles()
		
	#If the tile you clicked has a unit that can be attacked, damage it
	elif selected_unit.get_type() != "abstract_unit" and currently_clicked_tile.can_attack_space:
		print("attacked unit")
		selected_unit.expend_attack()
		
		#If a unit attacks, it uses up its movement as well
		selected_unit.expend_movement()
		selected_unit.update_selection_icon()
		emit_signal("ally_has_moved")
		
		#damage the targeted unit by the selected unit's attack power
		get_unit(Vector2(gridX,gridY)).damage_by(selected_unit.get_attack_power());
		reset_tiles()
		emit_signal("ally_has_attacked")
	else:
		reset_tiles()
		select_unit(gridX,gridY)

#Selects a unit on the grid if it matches with the unit object passed in
func select_unit_by_object(unit):
	unselect_previously_selected_unit()
	#Searc the unit array for the given object
	for i in range(0,8):
		for j in range(0,8):
			if unit == unitArray[i][j] and unit.get_team() == acting_team and not unit.is_dead() and unit.has_actions():
				selected_unit = unitArray[i][j]
				selected_unit.set_selected()
				selected_unit_coordinate = Vector2(i,j)
				emit_signal("ally_unit_selected",selected_unit)
				if selected_unit.has_attacked:
					emit_signal("ally_has_attacked")
				if selected_unit.has_moved:
					emit_signal("ally_has_moved")

#Selects the unit at the given coordinate on the grid
func select_unit(gridX,gridY):
	unselect_previously_selected_unit()
	var currently_clicked_unit = unitArray[gridX][gridY]
	if currently_clicked_unit.get_type() != "abstract_unit" and currently_clicked_unit.get_team() == acting_team and not currently_clicked_unit.is_dead() and currently_clicked_unit.has_actions():
		selected_unit = currently_clicked_unit
		selected_unit.set_selected()
		selected_unit_coordinate = Vector2(gridX,gridY)
		emit_signal("ally_unit_selected",selected_unit)
		if currently_clicked_unit.has_attacked:
			emit_signal("ally_has_attacked")
		if currently_clicked_unit.has_moved:
			emit_signal("ally_has_moved")
	elif currently_clicked_unit.get_type() != "abstract_unit" and (currently_clicked_unit.get_team() != acting_team or currently_clicked_unit.is_dead() or !currently_clicked_unit.has_actions()):
		emit_signal("dummy_unit_selected")
		meep_merp.play()
		selected_unit = dummy_unit
		selected_unit_coordinate = Vector2(-1,-1)
	else:
		emit_signal("dummy_unit_selected")
		selected_unit = dummy_unit
		selected_unit_coordinate = Vector2(-1,-1)

#Unselects the previous selected and resets tile highlights
func unselect_previously_selected_unit():
	selected_unit.set_unselected()
	selected_unit = dummy_unit
	reset_tiles()

func show_movement_options():
	reset_tiles()
	process_moves(selected_unit.get_movement_moves(),selected_unit,selected_unit_coordinate.x,selected_unit_coordinate.y, "movement")

func show_attack_options():
	reset_tiles()
	process_moves(selected_unit.get_attack_moves(),selected_unit,selected_unit_coordinate.x,selected_unit_coordinate.y, "attack")

func process_moves(unit_moves, unit, gridX, gridY, move_type):
	for move in unit_moves:
		var atom = move.atom
		# The places that will be highlighted
		var possible_positions = []
		# The places that will be highlighted subtly
		var subtle_highlight_positions = []
		var unavailable_positions = []
		# This is an array of tuples, of form [x mult, y mult, invert]
		var directions = []
		
		# This will make a list of directions for us to check.
		for x in [1, -1]:
			for y in [1, -1]:
				directions.append([x, y, false])
				directions.append([x,y, true])
		
		# print(directions)
	
		var count = 1
		if move.rider:
			count = max(board_y_size, board_x_size)
		# print(count)
		for d in directions:
			var mode = "active"
			var dx = atom.x
			var dy = atom.y
			if d[2]:
				dx = atom.y
				dy = atom.x
			dx *= d[0]
			dy *= d[1]
			for m in range(1,count + 1):
				# print(m)
				var position = Vector2(gridX + (dx * m), gridY + (dy * m))
				if not position_in_bounds(position):
					# We've hit the end of this direction, let's stop
					break
				# Get the tile we are currently looking at
				var tile = get_tile(position)
				if move_type == "attack":
					if unit.can_attack(get_unit(position)) and mode == "active":
						possible_positions.append(position)
					elif mode == "passive":
						unavailable_positions.append(position)
					else:
						subtle_highlight_positions.append(position)
				# We do the pass through check after the attack check, as otherwise the check would block us from attacking pieces
				if not unit.can_pass_through(tile, move_type):
					mode = "passive"
					#break
				if move_type == "movement":
					if unit.can_occupy(tile) and mode == "active":
						possible_positions.append(position)
					else:
						unavailable_positions.append(position)
				
			
		highlight_tiles(possible_positions, move_type)
		highlight_tiles(subtle_highlight_positions, move_type + "_subtle")
		#Don't highlight unavailable tiles for now
		#highlight_tiles(unavailable_positions, move_type + "_unavailable")


func highlight_tiles(possible_positions,atom_type):
	for tile_coordinate in possible_positions:
		if position_in_bounds(tile_coordinate):
			if atom_type == "movement":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_movement_option()
			elif atom_type == "attack":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_attack_option()
			elif atom_type == "attack_subtle":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_subtle_attack_option()
			elif atom_type == "movement_subtle":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_subtle_movement_option()
			elif atom_type == "movement_unavailable":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_unavailable_movement_option()
			elif atom_type == "attack_unavailable":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_unavailable_attack_option()

#Change this to do something useful for when the mouse enters a tile
#Currently highlights the currently moused over tile
func process_mouse_enter(gridX,gridY):
	var unit_to_be_processed = unitArray[gridX][gridY]
	if(unit_to_be_processed.get_type() != "abstract_unit"):
		unit_to_be_processed.display_stats()
	if unit_to_be_processed.get_team() == acting_team:
		if not unitArray[gridX][gridY].is_dead() and not unitArray[gridX][gridY].has_focus:
			unit_to_be_processed.display_stats()
			unit_to_be_processed.display_action_icons_hover()
	boardArray[gridX][gridY].toggle_outline()

#Change this to do something useful for when the mouse exits a tile
func process_mouse_exit(gridX,gridY):
	var unit_to_be_processed = unitArray[gridX][gridY]
	if !unit_to_be_processed.has_focus:
		unit_to_be_processed.hide_stats()
		if unit_to_be_processed.get_team() == acting_team and not unit_to_be_processed.is_dead():
			unit_to_be_processed.display_action_icons_passive()
	boardArray[gridX][gridY].toggle_outline()

func reset_tiles():
	for i in range(0,board_x_size):
		for j in range(0,board_y_size):
			boardArray[i][j].deactivate()

func reset_unit_moves():
	unselect_previously_selected_unit()
	for i in range(0,board_x_size):
		for j in range(0,board_y_size):
			unitArray[i][j].reset_moves()

func move_unit(startingX,startingY,endX,endY):
	var unit_to_move = unitArray[startingX][startingY]
	#move the unit in the array
	unitArray[endX][endY] = unit_to_move
	unit_to_move.z_index = 2 + boardArray[endX][endY].z_index
	#unit_to_move.z_index = unit_to_move.z_index - (endY - startingY) + (endX - startingX)
	unitArray[startingX][startingY] = dummy_unit
	
	#move the unit on the board
	unit_to_move.position = boardArray[endX][endY].get_placement_position().get_global_transform().get_origin()
	#unit_to_move.position = translate_grid_coordinate(endX,endY)
	
	#Set occupied for involved tiles
	boardArray[startingX][startingY].set_occupied(false)
	boardArray[endX][endY].set_occupied(true)
	
	#Set variables and send signals indicating this unit has moved.
	unit_to_move.expend_movement()
	selected_unit_coordinate = Vector2(endX,endY)
	unit_to_move.z_index = 2 + boardArray[endX][endY].z_index
	unit_to_move.print_info()
	print(unit_to_move.z_index)
	emit_signal("ally_has_moved")
	unit_to_move.moved()

func position_in_bounds(position):
	return position.x < board_x_size and position.x >= 0 and position.y < board_y_size and position.y >= 0

func switch_acting_team():
	if acting_team == 1:
		acting_team = 0
	elif acting_team == 0:
		acting_team = 1

func disconnect_board():
	for i in range(0,board_x_size):
		for j in range(0,board_y_size):
			boardArray[i][j].disconnect("mouse_entered", self, "process_mouse_enter")
			boardArray[i][j].disconnect("mouse_exited", self, "process_mouse_exit")
			boardArray[i][j].disconnect("clicked", self, "on_click")

#returns the actual coordinate that corresponds with a value in the 2D array of tiles.
func translate_grid_coordinate(gridX,gridY):
	return Vector2(starting_x + gridX * iso_x_offset + gridY * iso_x_offset, starting_y - gridY*iso_y_offset + gridX*iso_y_offset)