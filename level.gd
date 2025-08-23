extends Node2D

const EXPLOSION = preload("res://nodes/explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("click"):
		#var global_mouse_pos: Vector2 = get_global_mouse_position()
		#var explosion: Area2D = EXPLOSION.instantiate()
		#explosion.global_position = global_mouse_pos
		#add_child(explosion)
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://playground.tscn")
