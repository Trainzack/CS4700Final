extends Node

var tile_scene = preload("res://Tile.tscn")

#offsets used to populate the board. Values come from testing different positions
var iso_x_offset = 83*0.7
var iso_y_offset = 63*0.7
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
			tileNode.position = Vector2(300 + j*iso_x_offset + i*iso_x_offset, 370 - j*iso_y_offset + i*iso_y_offset)
			tileNode.z_index = Z - j
			tileNode.connect("mouse_entered", self, "process_mouse_enter", [i,j])
			tileNode.connect("mouse_exited", self, "process_mouse_exit", [i,j])
			tileArray.append(tileNode)
		boardArray.append(tileArray)

func process_mouse_enter(gridX,gridY):
	print(gridX, " ", gridY, " entered")
	boardArray[gridX][gridY].scale = Vector2(1.0,1.0)

func process_mouse_exit(gridX,gridY):
	print(gridX, " ", gridY, " exited")
	boardArray[gridX][gridY].scale = Vector2(0.7,0.7)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
