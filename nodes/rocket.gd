extends Area2D

@export var speed: float = 800.0
@export var explosion_scene: PackedScene
@export var explosion_strength: float = 1.0

const ROCKET_EXPLOSION = preload("res://nodes/rocket_explosion.tscn")
var direction: Vector2 = Vector2.ZERO
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()  # Rotate sprite to face movement
	position += direction * speed * delta

func _on_body_entered(body):
	if body not in get_tree().get_nodes_in_group("player"):
		explode()

func explode():
	# Remove rocket visuals and collision
	sprite_2d.queue_free()
	collision_shape_2d.queue_free()
	
	# Spawn main explosion (knockback + radius effect)
	if explosion_scene:
		var explosion: Area2D = explosion_scene.instantiate()
		explosion.global_position = global_position + (direction.normalized() * 25.0)

		# Pass the charge strength to the explosion
		explosion.strength = explosion_strength

		get_parent().call_deferred("add_child", explosion)
	
	# Spawn particle effect explosion (visual only)
	var explosion_fx: Explosion = ROCKET_EXPLOSION.instantiate()
	explosion_fx.global_position = global_position
	explosion_fx.emitting = true
	get_parent().call_deferred("add_child", explosion_fx)

	# Wait for particles to finish before cleanup
	await explosion_fx.finished
	explosion_fx.queue_free()
	await explosion_fx.tree_exited
	queue_free()




func _on_screen_check_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()
