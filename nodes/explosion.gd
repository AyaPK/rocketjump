extends Area2D

@export var base_force: float = 120.0   # default strongest push
@export var base_radius: float = 150.0  # default blast radius

@export var explosion_sfx: AudioStream

var strength: float = 1.0

func _ready():
	body_entered.connect(_on_body_entered)
	$CollisionShape2D.disabled = false

	var shape = $CollisionShape2D.shape
	if shape is CircleShape2D:
		shape.radius = base_radius * strength

	PlayerManager.player.camera.shake(strength*4)
	await get_tree().create_timer(0.05).timeout
	queue_free()

func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("player"):
		var to_body = body.global_position - global_position
		var distance = max(to_body.length(), 0.01)
		var dir = to_body.normalized()

		var force = base_force * strength
		var effective_radius = base_radius * strength

		var knock = force * (1.0 - clamp(distance / effective_radius, 0.0, 1.0))
		body.knockback = dir * knock
