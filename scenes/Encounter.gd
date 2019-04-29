extends Node


var tile_scene = preload("res://scenes/Tile.tscn")
var water_tile_scene = preload("res://scenes/WaterTile.tscn")
var wall_tile_scene = preload("res://scenes/WallTile.tscn")

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

var type = null

var difficulty = 0
var reward = 0

func get_difficulty():
	return difficulty
	
func get_reward():
	return reward

func select_encounter(encounter_type):
	type = encounter_type 
	

func build_board(board):
	
	for x in range(board.board_x_size):
		for y in range(board.board_y_size):
			var water = (y + 1 < (board.board_y_size * (3.0/4)) and y > (board.board_y_size * (1.0/4))) and (x + 1 > (board.board_x_size * (3.0/4)) or x < (board.board_x_size * (1.0/4)))
			var wall = (y + 1 < (board.board_y_size * (3.0/4)) and y > (board.board_y_size * (1.0/4))) and (x + 1 < (board.board_x_size * (3.0/4)) and x > (board.board_x_size * (1.0/4)))
			
			var tileNode = null
			if water:
				tileNode = water_tile_scene.instance()
			elif wall:
				tileNode = wall_tile_scene.instance()
			else:
				tileNode = tile_scene.instance()
			board.place_tile(Vector2(x, y), tileNode)
			
		
	var i = 0
	for x in range(0,board.board_x_size):
		var p = piece_scenes[i].instance()
		p.set_white()
		board.place_unit(p, x, 0)
		i = (i + 1)  % piece_scenes.size()
		
		p = piece_scenes[i].instance()
		p.set_black()
		board.place_unit(p, x, board.board_y_size-1)
		i = (i + 1)  % piece_scenes.size()