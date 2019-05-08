extends Node

onready var tile_map = $TileMap

var board = [
	"........",
	"........",
	"........",
	"........",
	"........",
	"........",
	"........",
	"........"
	]

var river_templates = [
	[
	".~~~~..=",
	"~~~.~~~.",
	"...=.~~~",
	],
	[
	"~~~~.~~=",
	"~~~~~~~~",
	".=~~~.=~",
	],
	[
	"..~~~~~.",
	"~~~..~~~",
	],
]

var mountain_templates = [
	[
	"=M=.M===",
	"=======.",
	"====..M.",
	],
	[
	"=====M==",
	"==M=====",
	"======M=",
	],
	[
	"M.======",
	"..==M=..",
	"M.===..M",
	],
]

var wall_mountain_templates = [
	[
	"MM====MM==MM===M===M====M",
	"MMMMMMMMMMMMMMMMMMMMMMMMM",
	"M===M====MM=====M==MM===M",
	]
]

var units = []

var suffix = " Field"

func generate():
	var add_wall = randi() % 2 == 0
	var add_hills = randi() % 2 == 0
	var add_dividing_river = randi() % 2 == 0
	var add_long_river = randi() % 2 == 0
	
	if add_wall:
		add_wall_mountains()
	
	if add_hills:
		add_mountains()
	
	if add_dividing_river:
		add_dividing_river()
	
	if add_long_river:
		add_long_river()
		
	if add_dividing_river and add_long_river:
		suffix = " Lake"
	elif add_long_river and add_wall:
		suffix = " Valley"
	elif add_long_river:
		suffix = " River"
	elif add_dividing_river:
		suffix = " Crossing"
	elif add_wall:
		suffix = " Mountain"
	elif add_hills:
		suffix = " Hills"
	else:
		suffix = " Field"

func add_dividing_river():
	var y_pos = int(rand_range(1,4))
	
	var flip_x = randi() % 2 == 0
	var flip_y = randi() % 2 == 0
	apply_template(river_templates[randi() % len(river_templates)], 0, y_pos, flip_x, flip_y)

func add_long_river():
	var x_pos = int(rand_range(-1,7))
	var flip_x = randi() % 2 == 0
	var flip_y = randi() % 2 == 0
	apply_template(river_templates[randi() % len(river_templates)], x_pos, 0, flip_x, flip_y, true)

func add_mountains():
	var y_pos = int(rand_range(1,4))
	
	var flip_x = randi() % 2 == 0
	var flip_y = randi() % 2 == 0
	apply_template(mountain_templates[randi() % len(mountain_templates)], 0, y_pos, flip_x, flip_y)
	flip_x = not flip_x
	flip_y = not flip_y
	y_pos = 7 - y_pos
	apply_template(mountain_templates[randi() % len(mountain_templates)], 0, y_pos, flip_x, flip_y)
	
func add_wall_mountains():
	var x_pos = -1
	if randi() % 2 == 0:
		x_pos = 6
	var y_pos = int(rand_range(-16,0))
	var flip_x = randi() % 2 == 0
	var flip_y = randi() % 2 == 0
	apply_template(wall_mountain_templates[randi() % len(wall_mountain_templates)], x_pos, y_pos, flip_x, flip_y, true)

func apply_template(template, pos_x=0, pos_y=0, x_flip = false, y_flip= false, r_flip = false):
	var y = -1
	for line in template:
		y += 1
		var x = -1
		for tile in line:
			x += 1
			if tile == "=":
				continue
			else:
				var target_y = (len(template) - 1) - y if y_flip else y
				var target_x = (len(template[0]) - 1) - x if x_flip else x
				if r_flip:
					var temp = target_y
					target_y = target_x
					target_x = temp
				target_x += pos_x
				target_y += pos_y
				if max(target_y, target_x) > 7 or min(target_y, target_x) < 0:
					continue
				set_tile(target_x, target_y, tile)
	
func get_pieces():
	return units
	
func get_board():
	return board

func set_tile(x, y, value):
	board[y][x] = value
