extends Node


var tile_scene = preload("res://scenes/Tile.tscn")
var water_tile_scene = preload("res://scenes/WaterTile.tscn")
var wall_tile_scene = preload("res://scenes/WallTile.tscn")

var pieces = {
	"B": preload("res://scenes/unit_scenes/Bishop.tscn"),
	"c": preload("res://scenes/unit_scenes/Commoner.tscn"),
	"C": preload("res://scenes/unit_scenes/Centaur.tscn"),
	"E": preload("res://scenes/unit_scenes/Elephant.tscn"),
	"G": preload("res://scenes/unit_scenes/Giraffe.tscn"),
	"K": preload("res://scenes/unit_scenes/King.tscn"),
	"N": preload("res://scenes/unit_scenes/Knight.tscn"),
	"M": preload("res://scenes/unit_scenes/Mann.tscn"),
	"P": preload("res://scenes/unit_scenes/Pawn.tscn"),
	"Q": preload("res://scenes/unit_scenes/Queen.tscn"),
	"R": preload("res://scenes/unit_scenes/Rook.tscn"),
	"U": preload("res://scenes/unit_scenes/Unicorn.tscn"),
	"Z": preload("res://scenes/unit_scenes/Zebra.tscn"),
}

var encounter_types = {
	"tut1":	[["........",
		"........",
		"~.......",
		"~~.MM.~M",
		"~~.MM.~M",
		"~.......",
		"........",
		"........",
	],[[3,0,"N",1],[3,7,"P",0]]],
}

var type = null

var difficulty = 0
var reward = 0

func get_difficulty():
	return difficulty
	
func get_reward():
	return reward

func select_encounter(encounter_type):
	type = encounter_type 


func build_test(board):
	place_tiles(board, ["........",
		"........",
		"........",
		"~~.MM.~~",
		"~~.MM.~~",
		"........",
		"........",
		"........",
	])
	
	var us = []
	var i = 0
	for x in range(0,board.board_x_size):
		
		us.append([x, 0, pieces.keys()[i], 1])
		i = (i + 1)  % pieces.keys().size()
		us.append([x, board.board_y_size - 1, pieces.keys()[i], 0])
		i = (i + 1)  % pieces.keys().size()
	place_units(board, us)

func build_board(board):
	if type in encounter_types:
		place_tiles(board, encounter_types[type][0])
		place_units(board, encounter_types[type][1])
	else:
		build_test(board)
		
		
func place_tiles(board, tiles):
	for x in range(board.board_x_size):
		for y in range(board.board_y_size):
			var tileNode = null
			if tiles[y][x] == "~":
				tileNode = water_tile_scene.instance()
			elif tiles[y][x] == "M":
				tileNode = wall_tile_scene.instance()
			else:
				tileNode = tile_scene.instance()
			board.place_tile(Vector2(x, y), tileNode)
			
func place_units(board, units):
	for u in units:
		# Form: [x, y, unit, team]
		
		var p = pieces[u[2]].instance()
		if u[3]:
			p.set_white()
		else:
			p.set_black()
		board.place_unit(p, u[0], u[1])
		
	
	