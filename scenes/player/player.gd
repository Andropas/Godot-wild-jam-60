extends CharacterBody2D


const SPEED = 300
const JUMP_VELOCITY = -400.0

signal changed_facing(x_value: int)

var hit_points = 4
@onready var start_position = position
@onready var stun_timer = $StunTimer
@onready var safe_timer = $SafeTimer
@onready var punch_timer = $PunchTimer
@onready var effect_anim = $EffectAnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_player = $AnimationPlayer
var is_relaxing = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var jump_timer = $JumpTimer
@onready var camera = $Camera2D
@onready var punch_area = $PunchArea
@onready var sprite = $Sprite2D
@onready var shape = $CollisionShape2D

const CAMERA_SPEED = 130

signal new_camera_tween
signal changed_hp(hp)
signal game_over
signal save_game(bench)

func take_damage(dmg, kickback = -1, stun = 0):
	if not safe_timer.time_left:
		hit_points -= dmg
		if kickback is Vector2:
			velocity = kickback
		stun_timer.start(stun)
		effect_anim.play("hit")
		safe_timer.start(1.5)
		punch_timer.stop()
		punch_area.get_node("Shape").set_deferred("disabled", true)
		emit_signal("changed_hp", hit_points)
		#print(hit_points)
		if hit_points <= 0:
			die()
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not stun_timer.time_left and not punch_timer.time_left and not is_relaxing:
		
		# Handle Jump.
		punch_area.get_node("Shape").disabled = true
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump_timer.start()
		if Input.is_action_just_released("jump"):
			jump_timer.stop()
		if Input.is_action_pressed("jump") and not jump_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
			

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		if Input.is_action_just_pressed("punch") and is_on_floor():
			punch_timer.start(0.4)
			direction = 0
		if sign(direction) != sign(velocity.x):
			emit_signal("changed_facing", sign(direction))
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if direction:
			scale.x = scale.y*direction
	elif is_relaxing:
		if Input.get_axis("move_left", "move_right") or Input.is_action_just_pressed("jump"):
			relax(false)
		velocity = Vector2()
		
	move_and_slide()
	
	anim_tree.set("parameters/conditions/is_idle", is_on_floor() and velocity.x == 0 and not is_relaxing)
	anim_tree.set("parameters/conditions/is_moving", is_on_floor() and velocity.x != 0)
	anim_tree.set("parameters/conditions/in_air", not is_on_floor())
	anim_tree.set("parameters/in_air/blend_position", velocity.y - 150)
	anim_tree.set("parameters/conditions/is_hurt", stun_timer.time_left)
	anim_tree.set("parameters/conditions/is_punch", punch_timer.time_left)
	anim_tree.set("parameters/conditions/is_relax", is_relaxing)
	

func call_kill(node, args):
	node.kill()

func _on_changed_facing(x_value):
	emit_signal("new_camera_tween")
	var camera_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD)
	camera_tween.tween_property(camera, "offset", x_value*Vector2(CAMERA_SPEED, 0),
	1*abs(x_value*CAMERA_SPEED - camera.offset.x)/CAMERA_SPEED)
	connect("new_camera_tween", camera_tween.kill)

func die():
	#get_tree().reload_current_scene()
	emit_signal("game_over")

func relax(value):
	if value:
		shape.set_deferred("disabled", true)
		hit_points = 4
		emit_signal("changed_hp", 4)
	else:
		shape.set_deferred("disabled", false)
	is_relaxing = value

func _on_punch_area_body_entered(body):
	if body != self and body.has_method("take_damage"):
		var kickback = Vector2(scale.y*150, -300)
		body.take_damage(1, kickback, 0.6)


func _on_punch_timer_timeout():
	punch_area.get_node("Shape").disabled = true


func _on_changed_hp(hp):
	if hp <= 2:
		sprite.texture = load("res://textures/player/spritesheet_hurt1.png")
	else:
		sprite.texture = load("res://textures/player/spritesheet.png")
