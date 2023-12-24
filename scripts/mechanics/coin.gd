extends Area3D

@onready var collision_shape_3d = $CollisionShape3D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer


func _process(delta):
	rotate_y(2 * delta)

func _on_coin_body_entered(body):
	if body.is_in_group("Player"):
		audio_stream_player.play()
		animation_player.play("picked_up")
		Global.coins += 1
		Global.emit_coins_updated()
		collision_shape_3d.disabled = true


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
