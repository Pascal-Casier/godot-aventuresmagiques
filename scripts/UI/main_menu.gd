extends Control
class_name MainMenu

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var music_stream_player = $MusicStreamPlayer

@onready var start_level = preload("res://scenes/levels/main.tscn") as PackedScene

func _ready():
	handle_connectin_signals()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			show()
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_option_pressed() -> void:
	margin_container.hide()
	options_menu.set_process(true)
	options_menu.show()
	
func on_exit_pressed() -> void:
	get_tree().quit()
	

func on_exit_options_menu() -> void:
	margin_container.show()
	options_menu.hide()

func handle_connectin_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	
