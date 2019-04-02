extends Node

var tile_scene = preload("res://Tile.tscn")

#offsets used to populate the board. Values come from testing different positions
var iso_x_offset = 84/2
var iso_y_offset = -63/2
var boardArray = []

func _ready():
	create_board()
	
	#test calls to set_cover to see how it would look
	#probably going to rename the function to set_highlight
	boardArray[0][0].set_cover("attack")
	boardArray[0][1].set_cover("attack")
	boardArray[0][2].set_cover("attack")
	boardArray[0][3].set_cover("attack")
	
	boardArray[3][5].set_cover("movement")
	boardArray[4][6].set_cover("movement")
	boardArray[4][4].set_cover("movement")
	boardArray[2][4].set_cover("movement")
	boardArray[2][6].set_cover("movement")


#Positions the tiles of the board onto the screen
#Also fills up the boardArray with tileArrays, creating a 2d array of tiles
func create_board():
	for i in range(8):
		var tileArray = []
		for j in range(8):
			var tileNode = tile_scene.instance()
			add_child(tileNode)
			if i%2 == j%2:
				tileNode.set_tile("white")
			else:
				tileNode.set_tile("black")
				#400,400 chosen as test starting position to populate the board from
			tileNode.position = Vector2(400 + i*iso_x_offset + j*iso_x_offset, 400 + i*iso_y_offset - j*iso_y_offset)
			tileArray.append(tileNode)
		boardArray.append(tileArray)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
