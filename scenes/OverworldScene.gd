extends Node


var node_scene = preload("res://scenes/OverworldNode.tscn")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var node = node_scene.instance()
	create_node(node, Vector2(100,100))
	
func create_node(node, position):
	add_child(node)
	node.position = Vector2(position.x, position.y)
	node.connect("clicked", self, "on_click", [node])

func on_click(node):
	print("clicked on node")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
