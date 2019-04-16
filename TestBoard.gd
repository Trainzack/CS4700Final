extends Node

var tile_scene = preload("res://Tile.tscn")

#offsets used to populate the board. Values come from testing different positions
var starting_x = 300
var starting_y = 370
var scaling_factor = 0.7
var iso_x_offset = 83 * scaling_factor
var iso_y_offset = 63 * scaling_factor
var y3D_offset = -36 * scaling_factor
var boardArray = []

func _ready():
	create_board()

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

func on_click(gridX,gridY):
	if boardArray[gridX][gridY].highlight_type == "attack":
		boardArray[gridX][gridY].set_highlight("movement")
	elif boardArray[gridX][gridY].highlight_type == "movement":
		boardArray[gridX][gridY].set_highlight("none")
	elif boardArray[gridX][gridY].highlight_type == "none":
		boardArray[gridX][gridY].set_highlight("attack")

#Change this to do something useful for when the mouse enters a tile
func process_mouse_enter(gridX,gridY):
	print(gridX, " ", gridY, " entered")
	print(translate_grid_coordinate(gridX,gridY))
	boardArray[gridX][gridY].toggle_outline()

#Change this to do something useful for when the mouse exits a tile
func process_mouse_exit(gridX,gridY):
	print(gridX, " ", gridY, " exited")
	boardArray[gridX][gridY].toggle_outline()

#returns the actual coordinate
func translate_grid_coordinate(gridX,gridY):
	return Vector2(starting_x + gridX * iso_x_offset + gridY * iso_x_offset, starting_y - gridY*iso_y_offset + gridX*iso_y_offset)
#func _process(delta):