extends Area2D

@export var speed: float = 800.0
@export var explosion_scene: PackedScene
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
	sprite_2d.queue_free()
	collision_shape_2d.queue_free()
	if explosion_scene:
		var explosion: Area2D = explosion_scene.instantiate()
		explosion.global_position = global_position + (direction.normalized() * 25.0)
		get_parent().call_deferred("add_child", explosion)
	
	var explosion: Explosion = ROCKET_EXPLOSION.instantiate()
	get_parent().call_deferred("add_child", explosion)
	explosion.global_position = global_position
	explosion.emitting = true

	await explosion.finished
	queue_free()
