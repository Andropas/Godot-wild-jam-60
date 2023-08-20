extends Node2D


@onready var street = $Street
@onready var audio = $Street/AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready():
	street.set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_intro_tree_exited():
	street.set_process(true)
	audio.play()


func _on_audio_stream_player_2d_finished():
	audio.play()
