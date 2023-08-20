extends Node2D

@export var Templates = [preload("res://scenes/templates/base/template.tscn"), preload("res://scenes/templates/1.tscn")]
@export var Robots = [preload("res://scenes/robots/base/robot.tscn")]
@export var Bench = preload("res://scenes/bench/bench.tscn")

var templates_passed = 0
var templates = []
var last_bench
var player

func _ready():
	randomize()
	templates = [$Template]
	for t in templates:
		t.connect("template_finished", _on_template_finished)
	create_template(1)

func _on_template_finished(tmp):
	if tmp == templates[-2]:
		create_template(len(templates)+1)
	update_templates(tmp)

func update_templates(tmp):
	var index = templates.find(tmp)
	for i in range(len(templates)):
		if i < index - 1:
			templates[i].set_process(false)
		else:
			templates[i].set_process(true)

func add_robots(tmp, number):
	var robots = []
	for i in range(number):
		robots.append(Robots[0].instantiate())
	while robots:
		var tmp_spawn = tmp.robot_spawn.get_children()
		var spawn = tmp_spawn[randi()%len(tmp_spawn)].get_child(0)
		spawn.progress_ratio = randf()
		
		
		var robot = robots[0]
		robot.position = spawn.position + spawn.get_parent().position
		robots.erase(robot)
		tmp.add_child(robot)
		robot.shape.scale.x = 2*(randi() % 2) - 1

func add_bench(tmp):
	var bench = Bench.instantiate()
	var tmp_spawn = tmp.robot_spawn.get_children()
	var spawn = tmp_spawn[randi()%len(tmp_spawn)].get_child(0)
	spawn.progress_ratio = 1/6 + randf()/1.5
	bench.position = spawn.position + spawn.get_parent().position
	tmp.add_child(bench)

func create_template(num):
	#ADDING BENCH HERE
	if num % 4 == 0:
		var tmp = Templates[randi() % len(Templates)].instantiate()
		if len(templates):
			tmp.position.x = templates[len(templates)-1].finish_area.global_position.x
		else:
			tmp.position = Vector2()
		tmp.connect("template_finished", _on_template_finished)
		call_deferred("add_child", tmp)
		call_deferred("move_child", tmp, 0)
		templates.append(tmp)
		call_deferred("add_bench", tmp)
		
		
	#HERE ADDING ROBOTS
	else:
		var tmp = Templates[randi() % len(Templates)].instantiate()
		if len(templates):
			tmp.position.x = templates[len(templates)-1].finish_area.global_position.x
		else:
			tmp.position = Vector2()
		
		tmp.connect("template_finished", _on_template_finished)
		call_deferred("add_child", tmp)
		call_deferred("move_child", tmp, 0)
		templates.append(tmp)
		call_deferred("add_robots", tmp, 3 + int(num/4))
	

func _on_save_game(bench):
	last_bench = bench
	get_tree().call_group("persist", "save")

func load_save():
	if last_bench:
		update_templates(templates.find(last_bench.get_parent()))
		player.position = last_bench.global_position
		player.relax(true)
	else:
		player.position = player.start_position
		player.hit_points = 4
	get_tree().call_group("persist", "_on_play_again")
	

func _on_game_over():
	load_save()


func _on_child_entered_tree(node):
	if node.has_signal("save_game"):
		node.connect("save_game", _on_save_game)
		print("we have this")
	if node.has_signal("game_over"):
		node.connect("game_over", _on_game_over)
		player = node
