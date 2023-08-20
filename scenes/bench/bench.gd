extends Area2D


func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for obj in get_overlapping_bodies():
			if obj.is_in_group("player"):
				obj.relax(true)
				obj.emit_signal("save_game", self)
