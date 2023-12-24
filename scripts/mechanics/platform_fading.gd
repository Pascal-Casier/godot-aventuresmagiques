extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var collision_shape_3d = $platform_rock/tileBrickA_medium/StaticBody3D/CollisionShape3D
@onready var tile_brick_a_medium = $platform_rock/tileBrickA_medium

@export var anim_speed := 1.0


func _on_body_entered(body):
	if body.is_in_group("Player"):
		animation_player.speed_scale = anim_speed
		animation_player.play("fade")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade":
		collision_shape_3d.disabled = true
		tile_brick_a_medium.hide()
		timer.start()


func _on_timer_timeout():
	animation_player.play("reset")
	collision_shape_3d.disabled = false
	tile_brick_a_medium.show()
	
