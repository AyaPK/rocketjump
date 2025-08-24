class_name PlayerCamera
extends Camera2D

var shake_amplitude: float = 0.0
var shake_decay: float = 5.0
var shake_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if shake_amplitude > 0:
		shake_offset = Vector2(
			randf_range(-shake_amplitude, shake_amplitude),
			randf_range(-shake_amplitude, shake_amplitude)
		)
		shake_amplitude = max(shake_amplitude - shake_decay * delta, 0)
	else:
		shake_offset = Vector2.ZERO

	offset = shake_offset

func shake(amount: float, decay: float = 5.0) -> void:
	shake_amplitude = amount
	shake_decay = decay
