extends CharacterBody2D

@onready var gun: Sprite2D = $Visuals/Gun
@onready var visuals: Node2D = $Visuals

var face_left: bool

const GRAVITY = 900.0

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
