extends Area2D

signal save_game(bench)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for obj in get_overlapping_bodies():
			if obj.is_in_group("player"):
				obj.relax(not obj.is_relaxing)
