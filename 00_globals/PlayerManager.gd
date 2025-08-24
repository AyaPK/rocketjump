extends Node

var player: Player

var reload_time: float = 2.0
var rocket_count: int = 1

var abilities: Dictionary[String, bool] = {
	"charge_shot": true
}

func has_ability(ability: String) -> bool:
	return abilities[ability]
