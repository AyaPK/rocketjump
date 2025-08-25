class_name Player extends CharacterBody2D

@export var rocket_scene: PackedScene
@export var move_speed: float = 200.0
@export var air_control: float = 1

@export var max_charge_time: float = 2.0
@export var min_explosion_strength: float = 1
@export var max_explosion_strength: float = 1.2

var charging: bool = false
var charge_time: float = 3.0

@onready var gun: Sprite2D = $Visuals/Gun
@onready var visuals: Node2D = $Visuals
@onready var camera: PlayerCamera = $Camera2D

var face_left: bool
const GRAVITY = 700.0
var can_fire: bool = true
var knockback: Vector2 = Vector2.ZERO
var reload_time: float = 1.0

# ========= ABILITY FLAGS ===================
var can_charge: bool = false


func _ready() -> void:
	$FireTimer.wait_time = reload_time
	PlayerManager.player = self
	reload_time = PlayerManager.reload_time
	load_abilities()

func load_abilities() -> void:
	print("a")
	can_charge = PlayerManager.has_ability("charge_shot")

func _process(delta: float) -> void:
	$ProgressBar.value = ($FireTimer.time_left / $FireTimer.wait_time) * 100
	_calc_bars(delta)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

	var input_dir := Input.get_axis("move_left", "move_right")

	if is_on_floor():
		if input_dir != 0:
			velocity.x = input_dir * move_speed
		else:
			if knockback == Vector2.ZERO:
				velocity.x = 0
	else:
		if input_dir != 0:
			velocity.x = lerp(velocity.x, input_dir * move_speed, air_control * delta)

	velocity += knockback
	knockback = knockback.move_toward(Vector2.ZERO, 600 * delta)

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
	if can_charge:
		if event.is_action_pressed("click"):
			start_charging()
		elif event.is_action_released("click"):
			release_charge()
	else :
		if event.is_action_pressed("click"):
			fire_rocket()

func fire_rocket():
	if can_fire:
		if rocket_scene == null:
			return
		$ShootSFX.play()
		var rocket = rocket_scene.instantiate()
		var global_mouse_pos = get_global_mouse_position()
		var dir = (global_mouse_pos - gun.global_position).normalized()

		rocket.global_position = gun.global_position
		rocket.direction = dir
		get_parent().add_child(rocket)

		if not is_on_floor():
			var recoil_strength: float = 60.0
			knockback += -dir * recoil_strength
		can_fire = false
		$FireTimer.start()

func _on_fire_timer_timeout() -> void:
	can_fire = true

func start_charging():
	if can_fire:
		$ChargeSFX.play()
		charging = true
		charge_time = 0.0

func release_charge():
	if charging and can_fire:
		$ChargeSFX.stop()
		charging = false
		fire_rocket_with_charge(charge_time)
		$FireTimer.start()
		can_fire = false

func fire_rocket_with_charge(charge: float):
	if rocket_scene == null:
		return
	$ShootSFX.play()
	var rocket = rocket_scene.instantiate()
	var global_mouse_pos = get_global_mouse_position()
	var dir = (global_mouse_pos - gun.global_position).normalized()

	rocket.global_position = gun.global_position
	rocket.direction = dir

	var t = charge / max_charge_time
	rocket.explosion_strength = lerp(min_explosion_strength, max_explosion_strength, t)

	get_parent().add_child(rocket)

	if not is_on_floor():
		var recoil_strength: float = 60.0 * (1.0 + t)
		knockback += -dir * recoil_strength

func _calc_bars(delta: float) -> void:
	if charging:
		charge_time = min(charge_time + delta, max_charge_time)
		$ChargeBar.value = (charge_time / max_charge_time) * 100
		if $ChargeBar.value == 100:
			release_charge()
	else:
		$ChargeBar.value -= 1
	if $ChargeBar.value <= 10.0:
		$ChargeBar.hide()
	else:
		$ChargeBar.show()
	
	if $ProgressBar.value == 0:
		$ProgressBar.hide()
	else:
		$ProgressBar.show()
