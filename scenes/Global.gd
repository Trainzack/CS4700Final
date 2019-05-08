extends Node

onready var sound_confirm = $SoundConfirm

func _ready():
	# Random seed
    randomize()