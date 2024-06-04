extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 600.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D


func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("move_left", "move_right")	
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animations(input_axis)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 4:
			velocity.y = JUMP_VELOCITY / 4

func handle_acceleration(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		if abs(velocity.x) < SPEED:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
