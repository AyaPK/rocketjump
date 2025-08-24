extends Node2D

const EXPLOSION = preload("res://nodes/explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://playground.tscn")
