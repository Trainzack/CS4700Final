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
var currentlyClicked
var previouslyClicked = unit_scene.instance()

func _ready():
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
			var unit = unit_scene.instance()
			unit.position = translate_grid_coordinate(i,j)
			add_child(unit)
			tempUnitArray.append(unit)
		unitArray.append(tempUnitArray)

#Place a unit on the board
func place_unit(placed_unit, gridX, gridY):
	placed_unit.position = translate_grid_coordinate(gridX,gridY)
	add_child(placed_unit)
	unitArray[gridX][gridY] = placed_unit

#Deselects the previously selected unit and activates a different one.
func on_click(gridX,gridY):
	reset_tiles()
	previouslyClicked.set_unselected()
	currentlyClicked = unitArray[gridX][gridY]
	previouslyClicked = currentlyClicked
	currentlyClicked.print_info()
	if currentlyClicked.get_type() != "abstract_unit":
		currentlyClicked.set_selected()
	if currentlyClicked.get_type() == "knight":
		process_movement_atoms(currentlyClicked.get_movement_atoms(),gridX,gridY)

func process_movement_atoms(movement_atoms, gridX, gridY):
	for atom in movement_atoms:
		var possible_positions = []
		possible_positions.append(Vector2(gridX + atom.x, gridY + atom.y))
		possible_positions.append(Vector2(gridX + atom.x, gridY - atom.y))
		possible_positions.append(Vector2(gridX - atom.x, gridY + atom.y))
		possible_positions.append(Vector2(gridX - atom.x, gridX - atom.y))
		for tile_coordinate in possible_positions:
			if tile_coordinate.x < 8 and tile_coordinate.x >= 0 and tile_coordinate.y < 8 and tile_coordinate.y >= 0:
				boardArray[tile_coordinate.x][tile_coordinate.y].set_highlight("movement")

#Change this to do something useful for when the mouse enters a tile
#Currently highlights the currently moused over tile
func process_mouse_enter(gridX,gridY):
	#print(gridX, " ", gridY, " entered")
	#print(translate_grid_coordinate(gridX,gridY))
	boardArray[gridX][gridY].toggle_outline()

#Change this to do something useful for when the mouse exits a tile
func process_mouse_exit(gridX,gridY):
	#print(gridX, " ", gridY, " exited")
	boardArray[gridX][gridY].toggle_outline()

func reset_tiles():
	for i in range(0,8):
		for j in range(0,8):
			boardArray[i][j].deactivate()

#returns the actual coordinate that corresponds with a value in the 2D array of tiles.
func translate_grid_coordinate(gridX,gridY):
	return Vector2(starting_x + gridX * iso_x_offset + gridY * iso_x_offset, starting_y - gridY*iso_y_offset + gridX*iso_y_offset)

#func _process(delta):