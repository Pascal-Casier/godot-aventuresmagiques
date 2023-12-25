extends Node3D

@export var btn_number : int = 0
@onready var audio_stream_player = $AudioStreamPlayer



func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		audio_stream_player.play()
		Global.emit_open_door_gate(btn_number)
