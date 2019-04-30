extends Node


var tile_scene = preload("res://scenes/Tile.tscn")
var water_tile_scene = preload("res://scenes/WaterTile.tscn")
var wall_tile_scene = preload("res://scenes/WallTile.tscn")

var names = ["Ace", "Ache", "Age", "Air", "Alchemy", "Ale", "Allegiance", "Alliance", "Ally", "Amber", "Amethyst", "Ancient", "Angel", "Anger", "Anguish", "Animal", "Ankle", "Anvil", "Ape", "Apex", "Apogee", "Appearance", "Apple", "Aquamarine", "Arch", "Arena", "Arm", "Armor", "Armory", "Arrow", "Artifact", "Artifice", "Ash", "Assault", "Assembly", "Attack", "Attic", "Aunt", "Aura", "Author", "Autonomy", "Autumn", "Avalanche", "Axe", "Baby", "Back", "Bait", "Baker", "Balance", "Ball", "Band", "Band", "Bandit", "Bane", "Bank", "Banner", "Bar", "Barb", "Barbarian", "Barricade", "Basis", "Basin", "Bath", "Battle", "Beach", "Beak", "Bean", "Bear", "Beard", "Beast", "Bed", "Bee", "Beer", "Beetle", "Beginning", "Beguiler", "Belch", "Bell", "Belly", "Belt", "Bend", "Berry", "Betrayal", "Bile", "Bin", "Bird", "Birth", "Bite", "Blade", "Blame", "Blanket", "Blaze", "Blight", "Blister", "Blizzard", "Bloat", "Block", "Blockade", "Blood", "Blossom", "Blot", "Blotch", "Blush", "Boar", "Board", "Boat", "Bodice", "Body", "Bog", "Boil", "Bolt", "Bone", "Book", "Boot", "Boredom", "Bottle", "Bottom", "Boulder", "Bow", "Bowel", "Bowel", "Bowl", "Boy", "Braid", "Brain", "Brand", "Brass", "Bravery", "Breach", "Bread", "Breaker", "Breakfast", "Breath", "Breeches", "Breed", "Brew", "Bride", "Bridge", "Bridle", "Brigand", "Brilliance", "Brim", "Bristle", "Bronze", "Brother", "Brunch", "Brush", "Brute", "Buck", "Buckle", "Bud", "Bug", "Bulb", "Bulwark", "Bunch", "Bunion", "Bunny", "Burden", "Burn", "Burial", "Bush", "Bushel", "Bust", "Buster", "Butcher", "Butter", "Butterfly", "Button", "Buzzard", "Cactus", "Cad", "Cage", "Cake", "Call", "Callus", "Calm", "Camp", "Cancer", "Candle", "Candy", "Canker", "Canyon", "Carnage", "Casket", "Castle", "Cat", "Catch", "Cathedral", "Cave", "Cavern", "Ceiling", "Cell", "Chain", "Chamber", "Champion", "Chance", "Channel", "Chant", "Chaos", "Chapel", "Charcoal", "Charm", "Chasm", "Cheese", "Chestnut", "Child", "Chill", "Chip", "Chocolate", "Chunk", "Church", "Cinder", "Cinnamon", "Circle", "Circumstance", "Citadel", "Clam", "Clan", "Clash", "Clasp", "Claw", "Clearing", "Cleft", "Climate", "Climax", "Clinch", "Cloak", "Clock", "Clod", "Cloister", "Closet", "Cloud", "Clout", "Club", "Cluster", "Clutch", "Clutter", "Coal", "Coast", "Cobalt", "Cobra", "Coil", "Coincidence", "Color", "Column", "Combat", "Comedy", "Comet", "Communion", "Compassion", "Confederacy", "Confidence", "Conflict", "Confusion", "Conjurer", "Conqueror", "Construct", "Container", "Contempt", "Contest", "Continent", "Contingency", "Contingent", "Control", "Controller", "Convenience", "Convent", "Cook", "Copper", "Corridor", "Cosmos", "Cottage", "Cotton", "Council", "Counsellor", "Couple", "Courage", "Courtesy", "Coven", "Cover", "Crab", "Crack", "Cradle", "Craft", "Crater", "Craze", "Cream", "Creature", "Creed", "Creek", "Creep", "Crescent", "Crest", "Crevice", "Crew", "Critter", "Cross", "Crow", "Crowd", "Crown", "Crucifixion", "Crusher", "Crux", "Crypt", "Crystal", "Cudgel", "Cult", "Cup", "Curl", "Curse", "Cusp", "Cut", "Cyclone", "Cyst", "Dabbler", "Dagger", "Dale", "Dance", "Danger", "Date", "Date", "Daub", "Dawn", "Day", "Dead", "Dearth", "Death", "Decay", "Deceiver", "Decency", "Decision", "Decline", "Deep", "Deer", "Defect", "Defender", "Defense", "Deference", "Delight", "Dell", "Demon", "Den", "Dent", "Depression", "Depression", "Depth", "Desert", "Desk", "Despair", "Dessert", "Destiny", "Destroyer", "Deviance", "Devil", "Devourer", "Diamond", "Dike", "Dimension", "Dimple", "Dinner", "Dip", "Dirge", "Dirt", "Disappearance", "Discovery", "Disemboweler", "Disgust", "Dish", "Dispersal", "Distance", "Distraction", "Distraction", "Distrust", "Ditch", "Dive", "Diversion", "Diversion", "Doctrine", "Dog", "Domain", "Domicile", "Dominion", "Donkey", "Doom", "Door", "Dot", "Dragon", "Drain", "Drawl", "Dread", "Dream", "Dreg", "Dress", "Dress", "Drill", "Drink", "Drinker", "Drip", "Drool", "Droplet", "Drum", "Dump", "Dumpling", "Dune", "Dung", "Dungeon", "Dusk", "Dust", "Dweller", "Dwelling", "Dye", "Eagle", "Ear", "Earth", "Eater", "Echo", "Eel", "Egg", "Elbow", "Elder", "Embrace", "Emerald", "Empire", "Enchanter", "End", "Entrails", "Entrance", "Entry", "Epidemic", "Equivalence", "Erasure", "Escort", "Esteem", "Euphoria", "Evil", "Eviscerator", "Executioner", "Exit", "Eye", "Face", "Failure", "Faith", "Faith", "Fall", "Falsehood", "Fame", "Family", "Famine", "Fang", "Farm", "Fat", "Fate", "Father", "Fear", "Feast", "Feed", "Fell", "Fellowship", "Fence", "Fern", "Ferry", "Festival", "Fever", "Field", "Fiend", "Fight", "Figure", "Filth", "Fin", "Finder", "Finger", "Fire", "Fish", "Fisher", "Fissure", "Fist", "Flag", "Flame", "Flank", "Flare", "Flash", "Flax", "Flayer", "Flea", "Fleck", "Flesh", "Flicker", "Flight", "Flood", "Floor", "Flower", "Fluke", "Flute", "Fly", "Flier", "Focus", "Fog", "Fold", "Fool", "Foot", "Ford", "Forest", "Forever", "Fork", "Fortress", "Fortune", "Fortune", "Fountain", "Fragrance", "Frame", "Freckle", "Freedom", "Frenzy", "Friend", "Fright", "Frill", "Frog", "Frost", "Froth", "Fruit", "Funeral", "Fungus", "Fur", "Furnace", "Fury", "Future", "Gale", "Gall", "Gallery", "Galley", "Gallows", "Game", "Gang", "Garlic", "Garnish", "Gate", "Gaze", "Gear", "Gem", "General", "Genius", "Gerbil", "Ghost", "Ghoul", "Gift", "Gill", "Girder", "Girdle", "Girl", "Glacier", "Glade", "Gland", "Glaze", "Gleam", "Glee", "Glen", "Glimmer", "Glitter", "Gloom", "Glory", "Gloss", "Glove", "Glow", "Glutton", "Goad", "Goal", "Goat", "God", "Gold", "Goo", "Good", "Goose", "Gore", "Gorge", "Grain", "Granite", "Grape", "Grasp", "Grass", "Grave", "Gravel", "Grease", "Greed", "Grief", "Griffon", "Grip", "Gristle", "Grizzle", "Groove", "Grotto", "Group", "Grove", "Grower", "Growl", "Growth", "Grub", "Guard", "Guild", "Guile", "Guilt", "Guise", "Gulf", "Gulf", "Gulf", "Gully", "Gut", "Gutter", "Habit", "Hag", "Hail", "Hair", "Hall", "Hame", "Hammer", "Hammerer", "Hand", "Handle", "Hare", "Harmony", "Harvest", "Harvester", "Hatchet", "Hate", "Hatred", "Haunt", "Hawk", "Hay", "Haze", "Head", "Healer", "Healing", "Heart", "Hearth", "Heat", "Heather", "Heaven", "Hedge", "Hegemon", "Hell", "Helm", "Help", "Hermit", "Hero", "Hex", "Hide", "Hill", "Hip", "Hog", "Hold", "Hole", "Hollow", "Homage", "Home", "Honey", "Honor", "Hood", "Hoof", "Hop", "Hopper", "Hope", "Horn", "Horror", "Horse", "Hound", "Hour", "House", "Hovel", "Howl", "Hug", "Humor", "Hunger", "Hurricane", "Hut", "Ice", "Idol", "Ignorance", "Image", "Immortal", "Incense", "Inch", "Incident", "Inconvenience", "Infamy", "Inferno", "Influence", "Ink", "Inn", "Innocence", "Insect", "Insight", "Intricacy", "Iron", "Island", "Itch", "Ivory", "Ivy", "Jack", "Jackal", "Jade", "Jail", "Jailer", "Jaundice", "Jaw", "Jester", "Jewel", "Joke", "Joy", "Judge", "Juggler", "Juice", "Jump", "Jungle", "Justice", "Keeper", "Keg", "Key", "Killer", "Kin", "Kindling", "King", "Kingdom", "Kiss", "Knife", "Knight", "Knot", "Knower", "Knowledge", "Labor", "Labyrinth", "Lace", "Lake", "Lamb", "Lance", "Lancer", "Land", "Language", "Lantern", "Lard", "Lark", "Larva", "Lash", "Law", "Leader", "Leaf", "League", "Leak", "Leap", "Learning", "Leech", "Legend", "Lemon", "Lens", "Leopard", "Leper", "Leprosy", "Lesion", "Lesson", "Letter", "Library", "Lie", "Life", "Light", "Lightning", "Lilac", "Limb", "Lime", "Line", "Lion", "Lip", "Lizard", "Loaf", "Lobster", "Lock", "Lock", "Length", "Loot", "Lord", "Louse", "Love", "Lover", "Luck", "Lull", "Lunch", "Lung", "Lure", "Lust", "Luster", "Lute", "Luxury", "Lyric", "Machine", "Maggot", "Magic", "Magician", "Malice", "Malodor", "Man", "Mange", "Manor", "Mansion", "Marble", "Mark", "Market", "Marsh", "Martyr", "Master", "Mastery", "Match", "Match", "Maw", "Maze", "Mead", "Meadow", "Meal", "Meal", "Meat", "Mechanism", "Medicine", "Meeting", "Memory", "Menace", "Merchant", "Mesh", "Mess", "Messiah", "Metal", "Meteor", "Midnight", "Might", "Mile", "Mind", "Mine", "Minion", "Mire", "Mirror", "Mirth", "Mischief", "Misery", "Mist", "Mite", "Mob", "Mold", "Mole", "Monastery", "Monger", "Mongrel", "Monk", "Monkey", "Monster", "Moon", "Mop", "Moral", "Morass", "Morning", "Morsel", "Mortal", "Moss", "Moth", "Mother", "Mountain", "Mouse", "Mouth", "Muck", "Mucus", "Mud", "Muffin", "Mule", "Murder", "Murk", "Muscle", "Mush", "Mushroom", "Music", "Mystery", "Myth", "Nadir", "Nail", "Name", "Nature", "Negator", "Nest", "Net", "Nettle", "Newt", "Night", "Nightmare", "Noble", "Noose", "Nose", "Notch", "Number", "Nut", "Oak", "Oar", "Oat", "Obeisance", "Oblivion", "Obstacle", "Ocean", "Odor", "Oil", "Olive", "Omen", "One", "Onion", "Onslaught", "Ooze", "Oracle", "Orange", "Orb", "Order", "Order", "Organ", "Outrage", "Owl", "Owner", "Ownership", "Ox", "Pack", "Pad", "Paddle", "Page", "Pain", "Paint", "Palace", "Palisade", "Palm", "Panther", "Pantomime", "Pants", "Paper", "Partner", "Pass", "Passage", "Passion", "Past", "Pastime", "Path", "Pattern", "Peace", "Peach", "Peak", "Pear", "Pearl", "Pebble", "Peek", "Pelt", "Pepper", "Periwinkle", "Permanency", "Persuasion", "Persuader", "Pet", "Petal", "Phantom", "Phlegm", "Phrase", "Pick", "Pig", "Pillar", "Pimple", "Pine", "Pinnacle", "Pit", "Pitch", "Plague", "Plain", "Plait", "Plan", "Plane", "Planet", "Plank", "Plant", "Planter", "Plate", "Play", "Play", "Pleat", "Plot", "Plum", "Plunge", "Pocket", "Poem", "Poet", "Poetry", "Point", "Poison", "Poker", "Polish", "Pool", "Portal", "Portent", "Post", "Pot", "Power", "Practice", "Prairie", "Praise", "Prank", "Pregnancy", "Present", "Prestige", "Price", "Pride", "Priest", "Prince", "Princess", "Principle", "Prison", "Problem", "Prophecy", "Prophet", "Prowler", "Puke", "Pulley", "Pulp", "Pumpkin", "Punch", "Pungency", "Puppet", "Purge", "Pus", "Putrescence", "Puzzle", "Quake", "Quandary", "Queen", "Quest", "Quiescence", "Quill", "Rabbit", "Rabble", "Race", "Race", "Rack", "Radiance", "Rag", "Rage", "Rain", "Ram", "Rampage", "Rampart", "Rancor", "Raptor", "Rasp", "Rat", "Raunch", "Ravager", "Raven", "Ray", "Razor", "Realm", "Reason", "Recluse", "Reign", "Rein", "Release", "Relic", "Relief", "Renown", "Respect", "Reticence", "Reverence", "Reward", "Rhyme", "Rhythm", "Riddle", "Rider", "Rift", "Right", "Rim", "Ring", "Rip", "Ripper", "Risk", "Rite", "River", "Road", "Roar", "Rock", "Rogue", "Romance", "Roof", "Room", "Root", "Rooter", "Rope", "Rose", "Rot", "Rout", "Ruin", "Ruler", "Rumor", "Rust", "Sabre", "Sack", "Sacrifice", "Saffron", "Saint", "Salt", "Salute", "Salve", "Sanctuary", "Sanctum", "Sand", "Sandal", "Sap", "Satin", "Savage", "Savagery", "Savant", "Savior", "Scab", "Scale", "Scandal", "Scar", "Scenario", "Scholar", "Scoop", "Scorn", "Scorpion", "Scourge", "Scrap", "Scrape", "Scratch", "Scream", "Scribe", "Scuffle", "Sculpture", "Scum", "Sea", "Seal", "Seal", "Seam", "Search", "Season", "Secret", "Sect", "Seducer", "Seed", "Seer", "Seizure", "Sense", "Serpent", "Servant", "Sever", "Sewer", "Shack", "Shade", "Shadow", "Shaft", "Shame", "Shank", "Shark", "Sheen", "Shell", "Shelter", "Shield", "Shin", "Shingle", "Ship", "Shock", "Shore", "Shove", "Shovel", "Show", "Shower", "Shred", "Shriek", "Shrine", "Sick", "Side", "Siege", "Silence", "Silk", "Silt", "Silver", "Sin", "Sinew", "Song", "Sister", "Skewer", "Skin", "Skirt", "Skull", "Skunk", "Sky", "Slaughter", "Slave", "Slayer", "Sleeve", "Slime", "Sling", "Slit", "Sliver", "Slop", "Sloth", "Sludge", "Slug", "Smear", "Smile", "Smith", "Smoke", "Snack", "Snail", "Snake", "Snarl", "Sneer", "Snot", "Soap", "Socket", "Soil", "Soldier", "Soot", "Sorcerer", "Sorcery", "Sorrow", "Soul", "Sound", "Spark", "Sparkle", "Spasm", "Spawn", "Speech", "Speaker", "Spear", "Speck", "Spell", "Spice", "Spider", "Spike", "Spine", "Spiral", "Spire", "Spirit", "Spit", "Spite", "Spittle", "Splash", "Spoils", "Sponge", "Spoon", "Sport", "Spot", "Spray", "Spring", "Spring", "Spurn", "Spurt", "Spy", "Square", "Squid", "Staff", "Stake", "Stalker", "Stance", "Standard", "Star", "Start", "Stasis", "Steam", "Steed", "Steel", "Stench", "Steppe", "Stick", "Stigma", "Stockade", "Stoker", "Stone", "Stop", "Storm", "Stranger", "Strap", "Strategy", "Straw", "Stray", "Stream", "Strength", "Strife", "Strike", "String", "Stroke", "Stump", "Stunt", "Style", "Subordinate", "Sucker", "Suffering", "Sugar", "Suicide", "Suitor", "Summit", "Sun", "Supper", "Surprise", "Swallow", "Swamp", "Sweat", "Swine", "Sword", "Symmetry", "Syrup", "System", "Tactic", "Tail", "Taker", "Talon", "Tangle", "Tar", "Target", "Tarnish", "Tattoo", "Tax", "Teacher", "Tear", "Tempest", "Temple", "Temple", "Tentacle", "Terror", "Test", "Theater", "Thief", "Thimble", "Thirst", "Thorn", "Thrall", "Threat", "Thrift", "Throat", "Throne", "Thrower", "Thunder", "Tick", "Tick", "Tile", "Time", "Tin", "Tip", "Toad", "Toast", "Toe", "Tomb", "Tome", "Tone", "Tongs", "Tongue", "Tool", "Tooth", "Top", "Torch", "Tornado", "Torture", "Touch", "Tour", "Tower", "Town", "Trade", "Tragedy", "Trail", "Trammel", "Trance", "Trap", "Trash", "Treason", "Treasure", "Treasury", "Treat", "Tree", "Trench", "Tress", "Trial", "Triangle", "Tribe", "Tribute", "Trick", "Trickery", "Trifle", "Trim", "Trooper", "Trouble", "Trough", "Trumpet", "Truss", "Trust", "Truth", "Tub", "Tube", "Tuft", "Tulip", "Tummy", "Tumor", "Tundra", "Tunnel", "Turmoil", "Turquoise", "Tusk", "Twig", "Twilight", "Twine", "Twinkle", "Twist", "Typhoon", "Ulcer", "Umbra", "Uncle", "Union", "Universe", "Urge", "Urn", "Utterance", "Vale", "Valley", "Vandal", "Vault", "Vegetable", "Veil", "Velvet", "Venom", "Vermin", "Verse", "Vessel", "Vestibule", "Vice", "Victim", "Vigor", "Village", "Vine", "Violator", "Violence", "Viper", "Virgin", "Virtue", "Vise", "Vision", "Visionary", "Voice", "Void", "Volcano", "Vomit", "Vulture", "Wad", "Wail", "Walk", "Wall", "Wanderer", "Wane", "War", "Ward", "Warmth", "Warning", "Warrior", "Wart", "Wasp", "Waste", "Watch", "Water", "Wave", "Wax", "Way", "Wealth", "Weasel", "Weather", "Weathering", "Weaver", "Web", "Weed", "Weevil", "Weight", "Weird", "Wheat", "Wheel", "Whim", "Whip", "Whisker", "Whisky", "Whisper", "Will", "Wilt", "Wind", "Wine", "Wing", "Winnower", "Winter", "Wire", "Wisdom", "Wish", "Wisp", "Witch", "Woman", "Wonder", "Wood", "Word", "Work", "Worker", "World", "Worm", "Worry", "Worship", "Worshipper", "Worth", "Wrack", "Wraith", "Wrath", "Wreath", "Wretch", "Yarn", "Yawn", "Year", "Yearling", "Yell", "Yore", "Youth", "Zeal", "Zealot", "Zenith", "Zephyr"]
var suffixes = [" Camp", " Town", " Village", "ville", "borough", " Castle", " Keep", " Court", " Field", " Valley"]

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
	"mini":	[[
		"M......M",
		"M......M",
		"...MM...",
		"...MM...",
		"........",
		"..MMMM..",
		"M......M",
		"MM....MM",
	],[[2,0,"R",1],[3,0,"N",1],[4,0,"N",1],[5,0,"G",1],[4,5,"C",0],[5,5,"N",0]]],
}

var type = null
var title = "Error"


var difficulty = 0
var reward = 0

func get_difficulty():
	return difficulty
	
func get_reward():
	return reward

func select_encounter(encounter_type):
	type = encounter_type
	# Todo: add appropriate suffix
	title = names[randi() % len(names)] + suffixes[randi() % len(suffixes)]


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
		
	
	