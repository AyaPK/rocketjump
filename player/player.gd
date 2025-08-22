extends CharacterBody2D

@export var rocket_scene: PackedScene
@export var move_speed: float = 200.0
@export var air_control: float = 1 # percentage of control while in air (0.0 = none, 1.0 = full)

@onready var gun: Sprite2D = $Visuals/Gun
@onready var visuals: Node2D = $Visuals

var face_left: bool
const GRAVITY = 700.0

var knockback: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

	# Handle horizontal movement (both ground + air)
	var input_dir := Input.get_axis("move_left", "move_right")

	if is_on_floor():
		# Full ground control
		if input_dir != 0:
			velocity.x = input_dir * move_speed
		else:
			if knockback == Vector2.ZERO:
				velocity.x = 0
	else:
		# Limited air control (additive instead of instant snap)
		if input_dir != 0:
			velocity.x = lerp(velocity.x, input_dir * move_speed, air_control * delta)

	# Apply knockback (always applies)
	velocity += knockback
	knockback = knockback.move_toward(Vector2.ZERO, 600 * delta)

	# Gun rotation
	var global_mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = global_mouse_pos - gun.global_position

	if face_left:
		gun.rotation = direction.angle() + PI
	else:
		gun.rotation = -direction.angle() - PI * 2

	# Flip character based on mouse
	if global_mouse_pos.x > global_position.x:
		visuals.scale.x = -1
		face_left = false
	else:
		visuals.scale.x = 1
		face_left = true

	move_and_slide()


func _input(event):
	if event.is_action_pressed("click"):
		fire_rocket()


func fire_rocket():
	if rocket_scene == null:
		return

	var rocket = rocket_scene.instantiate()
	var global_mouse_pos = get_global_mouse_position()
	var dir = (global_mouse_pos - gun.global_position).normalized()

	rocket.global_position = gun.global_position
	rocket.direction = dir
	get_parent().add_child(rocket)
