extends Node2D

signal template_finished

var num
@onready var finish_area = $FinishArea
@onready var background = $Background/Street
@onready var middleground = $Middleground/Street
# Called when the node enters the scene tree for the first time.
func _ready():
	background.position = global_position
	middleground.position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_finish_area_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("template_finished")
