extends Control

@onready var progress_bar = $MarginContainer/VBoxContainer/HBoxContainer/ProgressBar

func _ready():
	Global.on_coins_updated.connect(on_coins_updated)
	Global.on_health_updated.connect(on_health_updated)
	Global.emit_coins_updated()
	Global.emit_health_update()
	
func on_coins_updated(coins):
	progress_bar.value = coins

func on_health_updated(value):
	progress_bar.value = value
