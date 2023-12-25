extends Area3D

@onready var audio_stream_player = $AudioStreamPlayer
@onready var key = $Key
@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("has key")
		Global.has_key = true
		Global.emit_key_found()
		animation_player.play("picked")
		audio_stream_player.play()
		
		
		

func _on_audio_stream_player_finished():
	queue_free()
