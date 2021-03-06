extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var master_scene = get_parent()


onready var card_container = $VBoxContainer/CardContainer
onready var encounter_name_label = $VBoxContainer/Label
onready var begin_button = $VBoxContainer/Button

var pieces = [
	preload("res://scenes/unit_scenes/Bishop.tscn"),
	preload("res://scenes/unit_scenes/Commoner.tscn"),
	preload("res://scenes/unit_scenes/Centaur.tscn"),
	preload("res://scenes/unit_scenes/Elephant.tscn"),
	preload("res://scenes/unit_scenes/Giraffe.tscn"),
	preload("res://scenes/unit_scenes/King.tscn"),
	preload("res://scenes/unit_scenes/Knight.tscn"),
	preload("res://scenes/unit_scenes/Mann.tscn"),
	preload("res://scenes/unit_scenes/Pawn.tscn"),
	preload("res://scenes/unit_scenes/Queen.tscn"),
	preload("res://scenes/unit_scenes/Rook.tscn"),
	preload("res://scenes/unit_scenes/Ship.tscn"),
	preload("res://scenes/unit_scenes/Unicorn.tscn"),
	preload("res://scenes/unit_scenes/Zebra.tscn"),
	preload("res://scenes/unit_scenes/Vanguard.tscn"),
	preload("res://scenes/unit_scenes/Guard.tscn"),
	preload("res://scenes/unit_scenes/Cannon.tscn"),
]

var unit_card_scene = preload("res://scenes/UnitBuyCard.tscn")

var encounter_scene = preload("res://scenes/Encounter.tscn")

var unit_cards = []

var units = [
 	[pieces[0].instance()],
	[pieces[0].instance()],
]

var encounter = null

func _ready():
	
	encounter = encounter_scene.instance()
	add_child(encounter)
	encounter.select_encounter("random")
	encounter_name_label.text = encounter.title
	
	begin_button.connect("pressed",self,"start_encounter")
	
	for con in card_container.get_children():
		var c = unit_card_scene.instance()
		var u = pieces[randi() % pieces.size()].instance()
		add_child(u)
		print(u.type)
		con.add_child(c)
		c.set_unit(u)
		remove_child(u)

func start_encounter():
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
	
func buy_unit(team, unit):
	pass
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
