extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

signal changed_facing(x_value: int)


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var jump_timer = $JumpTimer
@onready var camera = $Camera2D

const CAMERA_SPEED = 130

signal new_camera_tween


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_timer.start()
	if Input.is_action_just_released("jump"):
		jump_timer.stop()
	if Input.is_action_pressed("jump") and not jump_timer.is_stopped():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if sign(direction) != sign(velocity.x):
		emit_signal("changed_facing", sign(direction))
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func call_kill(node, args):
	node.kill()

func _on_changed_facing(x_value):
	emit_signal("new_camera_tween")
	var camera_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD)
	camera_tween.tween_property(camera, "offset", x_value*Vector2(CAMERA_SPEED, 0),
	1*abs(x_value*CAMERA_SPEED - camera.offset.x)/CAMERA_SPEED)
	connect("new_camera_tween", camera_tween.kill)
