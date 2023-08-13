extends CharacterBody2D


const SPEED = 100
var direction = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_groups = ["player"]
var target

@onready var pause_timer = $PauseTimer
@onready var derecognition = $DerecognitionRadar
@onready var recognition = $RecognitionRadar

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not pause_timer.time_left:
		direction = 0
		if target:
			direction = sign(target.position.x - position.x)
		velocity.x = direction*SPEED
		
	else:
		velocity.x = 0
	if velocity.x:
			scale.x = scale.y*sign(velocity.x)
		
	move_and_slide()


func _on_radar_body_entered(body):
	for g in target_groups:
		if body.is_in_group(g):
			target = body


func _on_radar_body_exited(body):
	if body == target and not body in recognition.get_overlapping_bodies():
		target = null


func _on_recognition_body_exited(body):
	if body == target and not body in derecognition.get_overlapping_bodies():
		target = null