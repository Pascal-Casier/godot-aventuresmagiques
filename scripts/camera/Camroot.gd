extends Node3D

var camrot_h := 0.0
var camrot_v := 0.0
var cam_v_max := 50.0
var cam_v_min := -10.0
var mouse_sensitivity := 0.1
var acceleration := 10.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.on_pause_mode.connect(pausing)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camrot_h += event.relative.x * mouse_sensitivity
		camrot_v += event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)

	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, -camrot_h, acceleration * delta)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, acceleration * delta)
	
	
func pausing(on):
	set_physics_process(!on)
