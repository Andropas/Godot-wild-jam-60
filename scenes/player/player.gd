extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

#signal changed_facing(x_value: int)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var jump_timer = $JumpTimer
@onready var camera = $Camera2D
#var camera_tween = Tween.new()
#var last_x_value = 1


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_timer.start()
	if Input.is_action_just_released("jump"):
		jump_timer.stop()
	if Input.is_action_pressed("jump") and jump_timer.time_left and not jump_timer.is_stopped():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	camera.position.x = velocity.x

	move_and_slide()


#func _on_changed_facing(x_value):
#	pass # Replace with function body.
