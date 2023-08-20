extends HBoxContainer

func _on_player_changed_hp(hp):
	var children = get_children()
	var i = 0
	for c in children:
		if i < hp:
			c.modulate.a = 255
		else:
			c.modulate.a = 0
		i += 1
	print(hp)
	


func _on_player_start_healing(hp):
	var heart = get_child(hp)
	heart.get_node("Anim").play("start_healing")


func _on_player_break_healing(hp):
	var heart = get_child(hp)
	heart.get_node("Anim").stop()
	heart.modulate.a = 0


