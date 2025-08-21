extends Area2D

@export var speed: float = 800.0
@export var explosion_scene: PackedScene

var direction: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body):
	if body not in get_tree().get_nodes_in_group("player"):
		explode()

func explode():
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position + (direction.normalized() * 25.0)
		get_parent().call_deferred("add_child", explosion)
	queue_free()
