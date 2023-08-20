extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$AnimationPlayer.play("menu")


func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	$ButtonPress.play()


func _on_quit_pressed():
	get_tree().quit()
	$ButtonPress.play()
