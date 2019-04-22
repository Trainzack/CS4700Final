extends Node

var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var tile_scene = preload("res://scenes/Tile.tscn")

var bishop_scene = preload("res://scenes/unit_scenes/Bishop.tscn")
var commoner_scene = preload("res://scenes/unit_scenes/Commoner.tscn")
var centaur_scene = preload("res://scenes/unit_scenes/Centaur.tscn")
var elephant_scene = preload("res://scenes/unit_scenes/Elephant.tscn")
var giraffe_scene = preload("res://scenes/unit_scenes/Giraffe.tscn")
var king_scene = preload("res://scenes/unit_scenes/King.tscn")
var knight_scene = preload("res://scenes/unit_scenes/Knight.tscn")
var mann_scene = preload("res://scenes/unit_scenes/Mann.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Pawn.tscn")
var queen_scene = preload("res://scenes/unit_scenes/Queen.tscn")
var rook_scene = preload("res://scenes/unit_scenes/Rook.tscn")
var unicorn_scene = preload("res://scenes/unit_scenes/Unicorn.tscn")
var zebra_scene = preload("res://scenes/unit_scenes/Zebra.tscn")



var piece_scenes = [bishop_scene, commoner_scene, centaur_scene, elephant_scene, giraffe_scene, king_scene, knight_scene, mann_scene, pawn_scene, queen_scene, rook_scene, unicorn_scene, zebra_scene]

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
	create_board()
	populate_board()
	
	var i = 0
	for x in range(0,board_x_size):
		var p = piece_scenes[i].instance()
		p.set_white()
		place_unit(p, x, 0)
		i = (i + 1)  % piece_scenes.size()
		
		p = piece_scenes[i].instance()
		p.set_black()
		place_unit(p, x, board_y_size-1)
		i = (i + 1)  % piece_scenes.size()

func get_tile(position):
	return boardArray[position.x][position.y]
	
func get_unit(position):
	return unitArray[position.x][position.y]


#Positions the tiles of the board onto the screen
#Also fills up the boardArray with tileArrays, creating a 2d array of tiles
#Tiles occupy z indeces 0-10
func create_board():
	for i in range(board_x_size):
		var Z = 8
		var tileArray = []
		for j in range(board_y_size):
			var tileNode = tile_scene.instance()
			add_child(tileNode)
			if i%2 == j%2:
				tileNode.set_tile_type("white")
			else:
				tileNode.set_tile_type("black")
				#400,400 chosen as test starting position to populate the board from
			tileNode.position = Vector2(starting_x + j*iso_x_offset + i*iso_x_offset, starting_y - j*iso_y_offset + i*iso_y_offset)
			tileNode.z_index = Z - j
			tileNode.connect("mouse_entered", self, "process_mouse_enter", [i,j])
			tileNode.connect("mouse_exited", self, "process_mouse_exit", [i,j])
			tileNode.connect("clicked", self, "on_click", [i,j])
			tileArray.append(tileNode)
		boardArray.append(tileArray)

#Populates the board with invisible dummy units. Currently this is important to
#be able to create an 8x8 array of units.
func populate_board():
	for i in range(0,board_x_size):
		var tempUnitArray = []
		for j in range(0,board_y_size):
			tempUnitArray.append(dummy_unit)
		unitArray.append(tempUnitArray)

#For initally placing a unit on the board
func place_unit(placed_unit, gridX, gridY):
	if(!boardArray[gridX][gridY].is_occupied()):
		boardArray[gridX][gridY].set_occupied(true)
		placed_unit.position = translate_grid_coordinate(gridX,gridY)
		placed_unit.z_index = placed_unit.z_index - gridY + gridX
		add_child(placed_unit)
		unitArray[gridX][gridY] = placed_unit
	else:
		print("Tile is occupado")

#Deselects the previously selected unit and activates a different one.
func on_click(gridX,gridY):
	var currently_clicked_tile = boardArray[gridX][gridY]
	
	if selected_unit.get_type() != "abstract_unit" and currently_clicked_tile.can_move_to:
		print("moved unit")
		move_unit(selected_unit_coordinate.x,selected_unit_coordinate.y,gridX,gridY)
		reset_tiles()
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
	boardArray[gridX][gridY].toggle_outline()

#Change this to do something useful for when the mouse exits a tile
func process_mouse_exit(gridX,gridY):
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
	unit_to_move.z_index = unit_to_move.z_index - (endY - startingY) + (endX - startingX)
	unitArray[startingX][startingY] = dummy_unit
	
	#move the unit on the board
	unit_to_move.position = translate_grid_coordinate(endX,endY)
	
	#Set occupied for involved tiles
	boardArray[startingX][startingY].set_occupied(false)
	boardArray[endX][endY].set_occupied(true)
	selected_unit.has_moved = true
	selected_unit_coordinate = Vector2(endX,endY)
	emit_signal("ally_has_moved")
	unit_to_move.moved()

func position_in_bounds(position):
	return position.x < board_x_size and position.x >= 0 and position.y < board_y_size and position.y >= 0

#returns the actual coordinate that corresponds with a value in the 2D array of tiles.
func translate_grid_coordinate(gridX,gridY):
	return Vector2(starting_x + gridX * iso_x_offset + gridY * iso_x_offset, starting_y - gridY*iso_y_offset + gridX*iso_y_offset)