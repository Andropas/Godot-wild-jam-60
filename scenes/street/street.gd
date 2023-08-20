extends Node2D

@export var Templates = [preload("res://scenes/templates/base/template.tscn"), preload("res://scenes/templates/1.tscn")]
@export var Robots = [preload("res://scenes/robots/base/robot.tscn")]

var templates_passed = 0
var templates = []

func _ready():
	randomize()
	templates = [$Template]
	for t in templates:
		t.connect("template_finished", _on_template_finished)
	create_template()
	

func _on_template_finished(tmp):
	"""if tmp == templates[-2]:
		create_template()
	var index = templates.find(tmp)
	
	for i in range(len(templates)):
		if i < index - 1:
			templates[i].set_process(true)
		else:
			templates[i].set_process(true)"""
	create_template()

func add_robots(tmp, number):
	var robots = []
	for i in range(number):
		robots.append(Robots[0].instantiate())
	while robots:
		var tmp_spawn = tmp.robot_spawn.get_children()
		var spawn = tmp_spawn[randi()%len(tmp_spawn)].get_child(0)
		print(randi()%len(tmp_spawn))
		spawn.progress_ratio = randf()
		
		
		var robot = robots[0]
		robot.position = spawn.position + spawn.get_parent().position
		robots.erase(robot)
		tmp.add_child(robot)
		robot.shape.scale.x = 2*(randi() % 2) - 1

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
	call_deferred("add_robots", tmp, 3)
	
	
