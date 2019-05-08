extends Node

onready var sound_confirm = $SoundConfirm

onready var sound_no = $SoundNo

func _ready():
	# Random seed
    randomize()
	
func confirmSound():
	sound_confirm.play()
	
func denySound():
	sound_no.play()
	