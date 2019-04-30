extends Node

var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var tile_scene = preload("res://scenes/Tile.tscn")
var water_tile_scene = preload("res://scenes/WaterTile.tscn")
var wall_tile_scene = preload("res://scenes/WallTile.tscn")

var encounter_scene = preload("res://scenes/Encounter.tscn")

#offsets used to populate the board. Values come from testing different positions
var starting_x = 300
var starting_y = 370
var iso_x_offset = 83*0.7
var iso_y_offset = 63*0.7
var y3D_offset = -36*0.7
var boardArray = []
var unitArray = []

var board_x_size = 8
var board_y_size = 8

var dummy_unit = unit_scene.instance()
var selected_unit = dummy_unit
var selected_unit_coordinate = Vector2(-1,-1)

signal ally_unit_selected
signal dummy_unit_selected
signal ally_has_moved
signal ally_has_attacked

func _ready():
	add_child(dummy_unit)

func get_tile(position):
	return boardArray[position.x][position.y]
	
func get_unit(position):
	return unitArray[position.x][position.y]

# Internal method for placing a particular tile in a particular place
func place_tile(position, tile):
	if not position_in_bounds(position):
		printerr("invalid tile position: " + position)
	else:
		# TODO: Remove the tile that's already here
		add_child(tile)
		print(position)
		if int(position.x)%2 == int(position.y)%2:
			tile.set_tile_type("white")
		else:
			tile.set_tile_type("black")
		tile.position = Vector2(starting_x + position.x*iso_x_offset + position.y*iso_x_offset, starting_y - position.y*iso_y_offset + position.x*iso_y_offset)
		tile.z_index = tile.z_index + (board_y_size - position.y)
		tile.connect("mouse_entered", self, "process_mouse_enter", [position.x,position.y])
		tile.connect("mouse_exited", self, "process_mouse_exit", [position.x,position.y])
		tile.connect("clicked", self, "on_click", [position.x,position.y])
		boardArray[position.x][position.y] = tile

#Positions the tiles of the board onto the screen
#Also fills up the boardArray with tileArrays, creating a 2d array of tiles
#Tiles occupy z indeces 0-10
#Generates the board based on an encounter object thats passed in
func create_board(encounter):
	# Create the 2D array that holds the tiles, and the array that holds the units
	for x in range(board_x_size):
		var tileArray = []
		var tempUnitArray = []
		for y in range(board_y_size):
			tileArray.append(null)
			tempUnitArray.append(dummy_unit)
		boardArray.append(tileArray)
		unitArray.append(tempUnitArray)
		
	#actually generate the board
	encounter.build_board(self)
	

#For initally placing a unit on the board
func place_unit(placed_unit, gridX, gridY):
	if(!boardArray[gridX][gridY].is_occupied()):
		boardArray[gridX][gridY].set_occupied(true)
		placed_unit.position = boardArray[gridX][gridY].get_placement_position().get_global_transform().get_origin()
		placed_unit.z_index = 9 + boardArray[gridX][gridY].z_index
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
		reset_tiles()
		
	#If the tile you clicked has a unit that can be attacked, damage it
	elif selected_unit.get_type() != "abstract_unit" and currently_clicked_tile.can_attack_space:
		print("attacked unit")
		selected_unit.has_attacked = true
		emit_signal("ally_has_attacked")
		
		#If a unit attacks, it uses up its movement as well
		selected_unit.has_moved = true
		emit_signal("ally_has_moved")
		get_unit(Vector2(gridX,gridY)).damage_by(selected_unit.get_attack_power());
		reset_tiles()
		pass
	else:
		reset_tiles()
		select_unit(gridX,gridY)

func select_unit(gridX,gridY):
	selected_unit.set_unselected()
	var currently_clicked_unit = unitArray[gridX][gridY]
	if currently_clicked_unit.get_type() != "abstract_unit":
		selected_unit = currently_clicked_unit
		selected_unit.set_selected()
		selected_unit_coordinate = Vector2(gridX,gridY)
		emit_signal("ally_unit_selected")
		if currently_clicked_unit.has_attacked:
			emit_signal("ally_has_attacked")
		if currently_clicked_unit.has_moved:
			emit_signal("ally_has_moved")
		
	else:
		emit_signal("dummy_unit_selected")
		selected_unit = dummy_unit
		selected_unit_coordinate = Vector2(-1,-1)

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
		# This is an array of tuples, of form [x mult, y mult, invert]
		var directions = []
		
		# This will make a list of directions for us to check.
		for x in [1, -1]:
			for y in [1, -1]:
				directions.append([x, y, false])
				directions.append([x,y, true])
		
		print(directions)
	
		var count = 1
		if move.rider:
			count = max(board_y_size, board_x_size)
		print(count)
		for d in directions:
			
			var dx = atom.x
			var dy = atom.y
			if d[2]:
				dx = atom.y
				dy = atom.x
			dx *= d[0]
			dy *= d[1]
			for m in range(1,count + 1):
				print(m)
				var position = Vector2(gridX + (dx * m), gridY + (dy * m))
				if not position_in_bounds(position):
					# We've hit the end of this direction, let's stop
					break
				# Get the tile we are currently looking at
				var tile = get_tile(position)
				if move_type == "attack":
					if unit.can_attack(get_unit(position)):
						possible_positions.append(position)
					else:
						subtle_highlight_positions.append(position)
				# We do the pass through check after the attack check, as otherwise the check would block us from attacking pieces
				if not unit.can_pass_through(tile):
					break
				if move_type == "movement" and unit.can_occupy(tile):
					possible_positions.append(position)
			
		highlight_tiles(possible_positions, move_type)
		highlight_tiles(subtle_highlight_positions, move_type + "_subtle")


func highlight_tiles(possible_positions,atom_type):
	for tile_coordinate in possible_positions:
		if position_in_bounds(tile_coordinate):
			if atom_type == "movement":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_movement_option()
			elif atom_type == "attack":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_attack_option()
			elif atom_type == "attack_subtle":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_subtle_attack_option()

#Change this to do something useful for when the mouse enters a tile
#Currently highlights the currently moused over tile
func process_mouse_enter(gridX,gridY):
	if(unitArray[gridX][gridY].get_type() != "abstract_unit"):
		unitArray[gridX][gridY].display_health()
	boardArray[gridX][gridY].toggle_outline()

#Change this to do something useful for when the mouse exits a tile
func process_mouse_exit(gridX,gridY):
	if !unitArray[gridX][gridY].has_focus:
		unitArray[gridX][gridY].hide_health()
	boardArray[gridX][gridY].toggle_outline()

func reset_tiles():
	for i in range(0,board_x_size):
		for j in range(0,board_y_size):
			boardArray[i][j].deactivate()

func reset_unit_moves():
	selected_unit.set_unselected()
	selected_unit = dummy_unit
	for i in range(0,board_x_size):
		for j in range(0,board_y_size):
			unitArray[i][j].reset_moves()

func move_unit(startingX,startingY,endX,endY):
	var unit_to_move = unitArray[startingX][startingY]
	#move the unit in the array
	unitArray[endX][endY] = unit_to_move
	unit_to_move.z_index = 9 + boardArray[endX][endY].z_index
	#unit_to_move.z_index = unit_to_move.z_index - (endY - startingY) + (endX - startingX)
	unitArray[startingX][startingY] = dummy_unit
	
	#move the unit on the board
	unit_to_move.position = boardArray[endX][endY].get_placement_position().get_global_transform().get_origin()
	#unit_to_move.position = translate_grid_coordinate(endX,endY)
	
	#Set occupied for involved tiles
	boardArray[startingX][startingY].set_occupied(false)
	boardArray[endX][endY].set_occupied(true)
	
	#Set variables and send signals indicating this unit has moved.
	selected_unit.has_moved = true
	selected_unit_coordinate = Vector2(endX,endY)
	emit_signal("ally_has_moved")
	unit_to_move.moved()

func position_in_bounds(position):
	return position.x < board_x_size and position.x >= 0 and position.y < board_y_size and position.y >= 0

#returns the actual coordinate that corresponds with a value in the 2D array of tiles.
func translate_grid_coordinate(gridX,gridY):
	return Vector2(starting_x + gridX * iso_x_offset + gridY * iso_x_offset, starting_y - gridY*iso_y_offset + gridX*iso_y_offset)