extends Area2D


#@export var Template: Resource

@onready var template = $Template
var shown = false

"""func _on_body_entered(body):
	if body.is_in_group("player"):
		template.get_node("AnimationPlayer").play("show_news")"""


func _on_body_exited(body):
	if body.is_in_group("player"):
		template.get_node("AnimationPlayer").play("hide_news")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for obj in get_overlapping_bodies():
			if obj.is_in_group("player") and not shown:
				template.get_node("AnimationPlayer").play("show_news")
				shown = true
			else: 
				template.get_node("AnimationPlayer").play("hide_news")
				shown = false


