extends Node3D

@export var highlight_material: StandardMaterial3D

@onready var animation_player = $AnimationPlayer
@onready var chest_top = $chestTop_rare

@onready var chest_material: StandardMaterial3D = chest_top.mesh.surface_get_material(0)
@onready var label = $Control/Label


var is_open := false

@warning_ignore("unused_parameter")
func _on_interactable_focused(interactor):
	if not is_open:
		add_highlight()
		label.show()


@warning_ignore("unused_parameter")
func _on_interactable_interacted(interactor):
	if not is_open:
		animation_player.play("open_chest")
		remove_highlight()
		$Interactable.queue_free()
		is_open = true
		label.hide()


@warning_ignore("unused_parameter")
func _on_interactable_unfocused(interactor):
	if not is_open:
		remove_highlight()
		label.hide()

func add_highlight() -> void:
	chest_top.set_surface_override_material(0, chest_material.duplicate())
	chest_top.get_surface_override_material(0).next_pass = highlight_material
	
func remove_highlight() -> void:
	chest_top.set_surface_override_material(0, null)
