extends HBoxContainer


func _on_player_changed_hp(hp):
	var children = get_children()
	var i = 0
	for c in children:
		if i < hp:
			c.show()
		else:
			c.hide()
		i += 1
	print(hp)
	
