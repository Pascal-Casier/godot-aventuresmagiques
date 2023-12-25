extends Node

var health := 45
var coins : int = 6
var has_key := false
var pausing := false

signal on_coins_updated
signal on_health_updated
signal on_key_found
signal on_pause_mode
signal open_door_gate

func emit_coins_updated():
	on_coins_updated.emit(coins)

func emit_health_update():
	on_health_updated.emit(health)

func emit_key_found():
	on_key_found.emit(has_key)

func emit_on_pause_mode():
	on_pause_mode.emit(pausing)

func emit_open_door_gate(door_nbr : int):
	open_door_gate.emit(door_nbr)
