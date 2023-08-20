extends CharacterBody2D


const SPEED = 250
var direction = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hit_points = 3
var target_groups = ["player"]
var alive = true
var target
@onready var target_pos = global_position
@onready var save_position = global_position
@onready var save_hp = 3

@onready var pause_timer = $PauseTimer
@onready var stun_timer = $StunTimer
@onready var derecognition = $DerecognitionRadar
@onready var recognition = $RecognitionRadar
@onready var damage_area = $DamageArea
@onready var damage_shape = $DamageArea/CollisionShape2D
@onready var shape = $CollisionShape2D

@onready var emotion_anim = $EmotionAnim
@onready var emotion = $Emotion
@onready var anim_tree = $AnimationTree
@onready var effect_anim = $EffectAnimationPlayer


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if not stun_timer.time_left:
		if not pause_timer.time_left:
			direction = 0
			if abs(target_pos.x - global_position.x) > 5:
					direction = sign(target_pos.x - global_position.x)
			elif target:
				#recognition.monitoring = false
				damage_shape.set_deferred("disabled", true)
				pause_timer.start()
				
		elif is_on_floor():
			direction = 0
		velocity.x = direction*SPEED
		if velocity.x:
			shape.scale.x = shape.scale.y*sign(velocity.x)
		
	move_and_slide()
	
	anim_tree.set("parameters/conditions/is_idle",(is_on_floor() and velocity.x == 0) or pause_timer.time_left)
	anim_tree.set("parameters/conditions/is_moving", velocity.x != 0)
	


func _on_radar_body_entered(body):
	for g in target_groups:
		if body.is_in_group(g):
			target = body
			emotion_anim.play("found_target")
			break


func _on_radar_body_exited(body):
	if body == target:
		target = null
		emotion_anim.play("lost_target")


func _on_recognition_body_exited(body):
	if body == target and not body in derecognition.get_overlapping_bodies():
		target = null

func update_target():
	if target:
		target_pos = target.position + Vector2(sign(target.position.x - global_position.x), 0)*120

func _on_pause_timer_timeout():
	damage_shape.set_deferred("disabled", false)
	update_target()


func _on_damage_area_body_entered(body):
	if alive:
		for g in target_groups:
			if body.is_in_group(g):
				if body.has_method("take_damage"):
					body.take_damage(1, Vector2(direction*150, -300), 0.5)
				break

func take_damage(dmg, kickback = -1, stun = 0):
	hit_points -= dmg
	if kickback is Vector2:
		velocity = kickback
	#effect_anim.play("hit")
	stun_timer.start(stun)
	#print(hit_points)
	if hit_points <= 0:
		die()
	effect_anim.play("hit")
	
	
func die():
	hide()
	alive = false
	damage_shape.set_deferred("disabled", true)

func save():
	save_position = global_position
	save_hp = hit_points

func _on_play_again():
	show()
	
	damage_shape.set_deferred("disabled", false)
	global_position = save_position
	hit_points = save_hp
	if save_hp > 0:
		alive = true
	else:
		queue_free()
	target_pos = global_position

func _on_stun_timer_timeout():
	pause_timer.start()
