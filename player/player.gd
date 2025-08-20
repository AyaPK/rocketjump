extends CharacterBody2D

@onready var gun: Sprite2D = $Gun
var face_left: bool

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var global_mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = global_mouse_pos - gun.global_position

	if face_left:
		gun.rotation = direction.angle() + PI
	else:
		gun.rotation = -direction.angle() - PI * 2

	if global_mouse_pos.x > global_position.x:
		scale.x = -1
		face_left = false
	else:
		scale.x = 1
		face_left = true
