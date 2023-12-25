extends Node3D

@onready var animation_player = $Rogue/AnimationPlayer
@onready var label = $Control/Label


func _on_interactable_focused(interactor):
	animation_player.play("Cheer")
	label.show()
	

func _on_interactable_interacted(interactor):
	if Dialogic.current_timeline != null:
		return
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start('test1')
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.pausing = true
	Global.emit_on_pause_mode()
	get_viewport().set_input_as_handled()
	

func _on_interactable_unfocused(interactor):
	animation_player.play("Idle")
	label.hide()

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.pausing = false
	Global.emit_on_pause_mode()
	
