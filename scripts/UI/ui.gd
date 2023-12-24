extends Control

@onready var progress_bar = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var coins_label = $MarginContainer/HBoxContainer/HBoxContainer/Label
@onready var key_picture = $MarginContainer/HBoxContainer/KeyPicture

func _ready():
	Global.on_coins_updated.connect(on_coins_updated)
	Global.on_health_updated.connect(on_health_updated)
	Global.on_key_found.connect(on_key_updated)
	Global.emit_coins_updated()
	Global.emit_health_update()
	Global.emit_key_found()
	
func on_coins_updated(coins):
	coins_label.text = str(coins)

func on_health_updated(value):
	progress_bar.value = value

func on_key_updated(has_key):
	key_picture.visible = has_key
