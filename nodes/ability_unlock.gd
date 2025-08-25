extends Area2D

const CHARGE_SHOT = preload("res://dialogue/pickups/charge_shot.dialogue")

@export var ability_to_unlock: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	DialogueManager.show_dialogue_balloon(CHARGE_SHOT, "start")
	PlayerManager.player.process_mode = Node.PROCESS_MODE_DISABLED
	PlayerManager.unlock_ability("charge_shot")
	PlayerManager.player.load_abilities()
	await DialogueManager.dialogue_ended
	queue_free()
	PlayerManager.player.process_mode = Node.PROCESS_MODE_ALWAYS
