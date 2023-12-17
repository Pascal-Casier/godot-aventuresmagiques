extends Node3D

@export var height : int = 2
@onready var sprite_3d = $Sprite3D
@onready var animation_player = $Lever3/AnimationPlayer
@onready var lift_stream_player = $liftStreamPlayer as AudioStreamPlayer
@onready var clic_stream_player = $clicStreamPlayer

var start_position := Vector3.ZERO
var end_position := Vector3.ZERO
var up := false

func _ready():
	start_position = $StaticBody3D.position
	end_position  = Vector3(0, height, 0)
	
func elevator_on():
	var my_tween = create_tween()
	my_tween.tween_property($StaticBody3D, "position", end_position, 2.0)
	lift_stream_player.play()
	up = true
	
func elevator_callback():
	var my_tween = create_tween()
	my_tween.tween_property($StaticBody3D, "position", start_position, 2.0)
	lift_stream_player.play()
	up = false

func _input(_event):
	if sprite_3d.visible == true:
		if Input.is_action_just_pressed("interact"):
			elevator_callback()
			animation_player.play("Lever_On")
			clic_stream_player.play()
			sprite_3d.visible = false
			
func _on_area_3d_body_entered(body):
	if body.is_in_group("Player") and not up:
		elevator_on()

func _on_area_lever_body_entered(body):
	if body.is_in_group("Player") and up:
		sprite_3d.show()

func _on_area_lever_body_exited(body):
	if body.is_in_group("Player"):
		sprite_3d.hide()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Lever_On":
		animation_player.play("Lever_Off")
		
