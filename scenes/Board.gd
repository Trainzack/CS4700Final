extends Node

var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var tile_scene = preload("res://scenes/Tile.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Pawn.tscn")
var mann_scene = preload("res://scenes/unit_scenes/Mann.tscn")
var knight_scene = preload("res://scenes/unit_scenes/Knight.tscn")
var bishop_scene = preload("res://scenes/unit_scenes/Bishop.tscn")
var rook_scene = preload("res://scenes/unit_scenes/Rook.tscn")

#offsets used to populate the board. Values come from testing different positions
var starting_x = 300
var starting_y = 370
var iso_x_offset = 83*0.7
var iso_y_offset = 63*0.7
var y3D_offset = -36*0.7
var boardArray = []
var unitArray = []

var previously_clicked_coordinate = Vector2(-1,-1)
var currently_clicked_tile
var previously_clicked_tile = tile_scene.instance()
var currently_clicked_unit
var previously_clicked_unit = unit_scene.instance()
var dummy_unit = unit_scene.instance()

func _ready():
	add_child(dummy_unit)
	create_board()
	populate_board()
	
	var mann = mann_scene.instance()
	place_unit(mann,4,6)
	
	var pawn = pawn_scene.instance()
	place_unit(pawn,2,2)
	
	var rook = rook_scene.instance()
	place_unit(rook,7,5)
	
	var knight = knight_scene.instance()
	place_unit(knight,5,5)
	var knight_2 = knight_scene.instance()
	place_unit(knight_2,1,1)

#Positions the tiles of the board onto the screen
#Also fills up the boardArray with tileArrays, creating a 2d array of tiles
#Tiles occupy z indeces 0-10
func create_board():
	for i in range(8):
		var Z = 8
		var tileArray = []
		for j in range(8):
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
	for i in range(0,8):
		var tempUnitArray = []
		for j in range(0,8):
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
	previously_clicked_unit.set_unselected()
	currently_clicked_unit = unitArray[gridX][gridY]
	currently_clicked_tile = boardArray[gridX][gridY]
	print(currently_clicked_tile.can_move_to)
	print(previously_clicked_unit.get_type())
	
	if previously_clicked_unit.get_type() != "abstract_unit" and currently_clicked_tile.can_move_to:
		print("moved unit")
		move_unit(previously_clicked_coordinate.x,previously_clicked_coordinate.y,gridX,gridY)
		reset_tiles()
	else:
		reset_tiles()
		select_unit(gridX,gridY)
	previously_clicked_tile = currently_clicked_tile
	previously_clicked_unit = currently_clicked_unit
	previously_clicked_coordinate = Vector2(gridX,gridY)
	

func select_unit(gridX,gridY):
	currently_clicked_unit.print_info()
	if currently_clicked_unit.get_type() != "abstract_unit":
		currently_clicked_unit.set_selected()
		print("unit selected")
	process_atoms(currently_clicked_unit.get_movement_atoms(),gridX,gridY,"movement")
	#process_atoms(currently_clicked_unit.get_attack_atoms(),gridX,gridY,"attack")

func process_atoms(unit_atoms, gridX, gridY, atom_type):
	for atom in unit_atoms:
		var possible_positions = []
		possible_positions.append(Vector2(gridX + atom.x, gridY + atom.y))
		possible_positions.append(Vector2(gridX + atom.x, gridY - atom.y))
		possible_positions.append(Vector2(gridX - atom.x, gridY + atom.y))
		possible_positions.append(Vector2(gridX - atom.x, gridY - atom.y))
		possible_positions.append(Vector2(gridX + atom.y, gridY + atom.x))
		possible_positions.append(Vector2(gridX + atom.y, gridY - atom.x))
		possible_positions.append(Vector2(gridX - atom.y, gridY + atom.x))
		possible_positions.append(Vector2(gridX - atom.y, gridY - atom.x))
		
		highlight_tiles(possible_positions, atom_type)

func highlight_tiles(possible_positions,atom_type):
	for tile_coordinate in possible_positions:
		if tile_coordinate.x < 8 and tile_coordinate.x >= 0 and tile_coordinate.y < 8 and tile_coordinate.y >= 0:
			if atom_type == "movement":
				print(tile_coordinate.x,tile_coordinate.y)
				boardArray[tile_coordinate.x][tile_coordinate.y].set_movement_option()
			elif atom_type == "attack":
				boardArray[tile_coordinate.x][tile_coordinate.y].set_attack_option()

#Change this to do something useful for when the mouse enters a tile
#Currently highlights the currently moused over tile
func process_mouse_enter(gridX,gridY):
	boardArray[gridX][gridY].toggle_outline()

#Change this to do something useful for when the mouse exits a tile
func process_mouse_exit(gridX,gridY):
	boardArray[gridX][gridY].toggle_outline()

func reset_tiles():
	for i in range(0,8):
		for j in range(0,8):
			boardArray[i][j].deactivate()

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

#returns the actual coordinate that corresponds with a value in the 2D array of tiles.
func translate_grid_coordinate(gridX,gridY):
	return Vector2(starting_x + gridX * iso_x_offset + gridY * iso_x_offset, starting_y - gridY*iso_y_offset + gridX*iso_y_offset)

#func _process(delta):