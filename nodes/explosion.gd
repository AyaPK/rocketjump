extends Area2D

@export var max_force: float = 120.0   # strongest push
@export var radius: float = 150.0       # blast radius

func _ready():
	body_entered.connect(_on_body_entered)
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(0.05).timeout
	queue_free() # explosion only lasts a short time

func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("player"):
		var to_body = body.global_position - global_position
		var distance = to_body.length()
		if distance == 0:
			distance = 0.01
		var dir = to_body.normalized()
		var strength = max_force * (1.0 - clamp(distance / radius, 0.0, 1.0))
		body.knockback = dir * strength
		
