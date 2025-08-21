extends CharacterBody2D

@export var rocket_scene: PackedScene

@onready var gun: Sprite2D = $Visuals/Gun
@onready var visuals: Node2D = $Visuals

var face_left: bool

const GRAVITY = 700.0

var knockback: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if velocity.y > 0:
			velocity.y = 0
		velocity.x = 0

	velocity += knockback

	knockback = knockback.move_toward(Vector2.ZERO, 600 * delta)
#
	var global_mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = global_mouse_pos - gun.global_position

	if face_left:
		gun.rotation = direction.angle() + PI
	else:
		gun.rotation = -direction.angle() - PI * 2

	if global_mouse_pos.x > global_position.x:
		visuals.scale.x = -1
		face_left = false
	else:
		visuals.scale.x = 1
		face_left = true
	move_and_slide()

func _input(event):
	if event.is_action_pressed("click"): # define "shoot" in Input Map (e.g. left mouse)
		fire_rocket()
		pass

func fire_rocket():
	if rocket_scene == null:
		return

	var rocket = rocket_scene.instantiate()
	var global_mouse_pos = get_global_mouse_position()
	var dir = (global_mouse_pos - gun.global_position).normalized()

	rocket.global_position = gun.global_position
	rocket.direction = dir
	get_parent().add_child(rocket)
