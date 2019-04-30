extends Node


var node_scene = preload("res://scenes/OverworldNode.tscn")

onready var node_container = $Container/Panel
onready var node_name = $Container/InfoPanel/NodeName


var node_distance = 80.0

# The number of nodes in the x and y direction
var node_x = 14
var node_y = 4

# The indicies of chokepoints
var chokepoint_locations = [0, 1, 2, 7, 13]

var chokepoint_types = {
	0: "tut1",
	1: "tut2",
	2: "tut3",
	7: "mini",
	13: "final"	
}

# Hold the nodes
var nodes = []

var selected_node = null

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	# Create all of the nodes
	for x in range(node_x):
		var node_line = []
		if x in chokepoint_locations:
			var n = node_scene.instance()
			# Todo: Make it a special chokepoint
			create_node(n, [x, float(node_y-1)/2])
			n.selectEncounter(chokepoint_types[x])
			node_line.append(n)
		else:
			for y in range(node_y):
				var n = node_scene.instance()
				create_node(n, [x,y])
				node_line.append(n)
				n.selectEncounter("en_" + str(x))
		nodes.append(node_line)
	
	# Link them together
	for x in range(node_x - 1):
		for y in range(node_y):
			if x in chokepoint_locations and x + 1 in chokepoint_locations:
				if y == 0:
					nodes[x][0].connect_node(nodes[x + 1][0])
			elif (x + 1) in chokepoint_locations:
				nodes[x][y].connect_node(nodes[x + 1][0])
			elif x in chokepoint_locations:
				nodes[x][0].connect_node(nodes[x + 1][y])
			else:
				nodes[x][y].connect_node(nodes[x + 1][y])
				# Randomly assign either a right branch or a left branch
				if randi()%2 == 0:
					if y < node_y - 1:
						nodes[x][y].connect_node(nodes[x + 1][y + 1])
				else:
					if y > 0:
						nodes[x][y].connect_node(nodes[x + 1][y - 1])
						
	
	
func create_node(node, position):
	node_container.add_child(node)
	node.position = Vector2((position[0] + 1) * node_distance, (position[1] + 0.5) * node_distance)
	node.connect("clicked", self, "on_click", [node])

func on_click(node):
	if not selected_node == null: 
		selected_node.unselect()
	selected_node = node
	selected_node.select()
	node_name.text = selected_node.get_name()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
