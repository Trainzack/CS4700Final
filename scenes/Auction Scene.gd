extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var master_scene = get_parent()


onready var card_container = $VBoxContainer/CardContainer
onready var encounter_name_label = $VBoxContainer/Label
onready var begin_button = $VBoxContainer/Button

var pieces = [
[

	preload("res://scenes/unit_scenes/Guard.tscn"),
	preload("res://scenes/unit_scenes/Knight.tscn"),
	preload("res://scenes/unit_scenes/Pawn.tscn"),
	preload("res://scenes/unit_scenes/Vanguard.tscn"),
	preload("res://scenes/unit_scenes/Mann.tscn"),
],
[
	preload("res://scenes/unit_scenes/Bishop.tscn"),
	preload("res://scenes/unit_scenes/Commoner.tscn"),
	preload("res://scenes/unit_scenes/Giraffe.tscn"),
	preload("res://scenes/unit_scenes/Rook.tscn"),
	preload("res://scenes/unit_scenes/Unicorn.tscn"),
	preload("res://scenes/unit_scenes/Zebra.tscn"),
],
[

	preload("res://scenes/unit_scenes/Cannon.tscn"),
	preload("res://scenes/unit_scenes/Queen.tscn"),
	preload("res://scenes/unit_scenes/Centaur.tscn"),
	preload("res://scenes/unit_scenes/Elephant.tscn"),
	preload("res://scenes/unit_scenes/King.tscn"),
]
]

var points_left = [
	20,
	20
]

var unit_card_scene = preload("res://scenes/UnitBuyCard.tscn")

var encounter_scene = preload("res://scenes/Encounter.tscn")

var unit_cards = []

var units = [
	[],
	[],
]

var encounter = null

func update_label():
	encounter_name_label.text = encounter.title + ", White: " + str(points_left[0]) + " CC, Black: " + str(points_left[1]) + " CC"

func _ready():
	
	refresh()
	
	
	begin_button.connect("pressed",self,"start_encounter")
	

func start_encounter():
	if len(units[0]) <= 0 or len(units[1]) <= 0:
		Global.denySound()
		return
	var team = -1
	for pieces in units:
		team += 1
		for piece in pieces:
			add_child(piece)
			remove_child(piece)
			if team == 0:
				piece.set_white()
			else:
				piece.set_black()
	encounter.set_teams(units[0], units[1])
	master_scene.begin_combat(encounter)
	
func buy_unit(unit, team):
	var u = unit.instance()
	if points_left[team] < u.get_cost() or len(units[team]) >= 12:
		Global.denySound()
		return
	units[team].append(u)
	points_left[team] -= u.get_cost()
	update_label()
	
# Called when we return to this scene from a sub-scene
func come_back():
	# TODO: refresh
	# master_scene.return_to_menu()
	refresh()
	

func refresh():
	units = [[],[],]
	points_left = [20,20]
	
	if encounter != null:
		remove_child(encounter)
	encounter = encounter_scene.instance()
	add_child(encounter)
	encounter.select_encounter("random")
	update_label()
	var i = 0
	for con in card_container.get_children():
		var group = int(i/2)
		for thing_to_remove in con.get_children():
			con.remove_child(thing_to_remove)
		var c = unit_card_scene.instance()
		var unit_scene = pieces[group][randi() % pieces[group].size()]
		var u = unit_scene.instance()
		add_child(u)
		print(u.type)
		con.add_child(c)
		c.set_unit(u)
		c.set_scene(unit_scene)
		c.connect("buy_pressed",self,"buy_unit")
		remove_child(u)
		i += 1

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
