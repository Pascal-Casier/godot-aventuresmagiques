extends RigidBody3D

@export var highlight_material: StandardMaterial3D
@onready var crate = $crate
@onready var crate_material: StandardMaterial3D = crate.mesh.surface_get_material(0)


func add_highlight() -> void:
	crate.set_surface_override_material(1, crate_material.duplicate())
	crate.get_surface_override_material(1).next_pass = highlight_material
	
func remove_highlight() -> void:
	crate.set_surface_override_material(1, null)

func _on_interactable_focused(interactor):
	add_highlight()

func _on_interactable_interacted(interactor):
	pass

func _on_interactable_unfocused(interactor):
	remove_highlight()
