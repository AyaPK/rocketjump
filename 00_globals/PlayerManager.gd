extends Node

var reload_time: float = 2.0
var rocket_count: int = 1

var abilities: Dictionary[String, bool] = {
	"charge_shot": false
}

func has_ability(ability: String) -> bool:
	return abilities[ability]
