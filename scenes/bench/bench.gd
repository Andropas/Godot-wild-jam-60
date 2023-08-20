extends Area2D

var sitter
@onready var regen_timer = $RegenTimer
@onready var particles = $GPUParticles2D
	

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for obj in get_overlapping_bodies():
			if obj.is_in_group("player"):
				sitter = obj
				obj.relax(true)
				obj.emit_signal("save_game", self)
				particles.emitting = true
	if sitter:
		if not sitter.is_relaxing:
			if regen_timer.time_left:
				sitter.emit_signal("break_healing", sitter.hit_points)
				regen_timer.stop()
			particles.emitting = false
			sitter = null
			
			
		else:
			if not regen_timer.time_left and sitter.hit_points < sitter.max_hit_points:
				regen_timer.start()
				sitter.emit_signal("start_healing", sitter.hit_points)
		


func _on_regen_timer_timeout():
	sitter.emit_signal("finish_healing", sitter.hit_points+1)
