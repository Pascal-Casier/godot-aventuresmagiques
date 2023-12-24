extends Node

var health := 100
var coins : int = 6

signal on_coins_updated
signal on_health_updated

func emit_coins_updated():
	on_coins_updated.emit(coins)

func emit_health_update():
	on_health_updated.emit(health)
