extends Node2D

@export var Templates = [preload("res://scenes/templates/base/template.tscn")]

var templates_passed = 0
var templates

func _ready():
	templates = [$Template]
	for t in templates:
		t.connect("template_finished", _on_template_finished)
	create_template()

func _on_dead_zone_body_entered(body):
	if body.has_method("die"):
		body.die()
	

func _on_template_finished():
	create_template()

func create_template():
	var tmp = Templates[randi() % len(Templates)].instantiate()
	if len(templates):
		tmp.position.x = templates[len(templates)-1].finish_area.global_position.x
	else:
		tmp.position = Vector2()
	tmp.connect("template_finished", _on_template_finished)
	call_deferred("add_child", tmp)
	call_deferred("move_child", tmp, 0)
	templates.append(tmp)
