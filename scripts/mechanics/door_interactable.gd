extends Node3D

@export var need_key : bool = false
var is_open: bool = false
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer
@onready var label_3d = $wall_doorway_door/Label3D


@warning_ignore("unused_parameter")
func _on_interactable_interacted(interactor: Interactor) -> void:
	if need_key and Global.has_key:
		if !is_open:
			animation_player.play("open_door")
			is_open = true
			label_3d.hide()
			Global.has_key = false
			Global.emit_key_found()
			need_key = false
	elif !need_key and !is_open:
		animation_player.play("open_door")
		is_open = true
		label_3d.hide()
		
	elif is_open:
			animation_player.play("close_door")
			is_open = false
	else:
		audio_stream_player.play()
		label_3d.show()
		
@warning_ignore("unused_parameter")
func _on_interactable_focused(interactor):
	$Control/Label.show()

@warning_ignore("unused_parameter")
func _on_interactable_unfocused(interactor):
	$Control/Label.hide()

