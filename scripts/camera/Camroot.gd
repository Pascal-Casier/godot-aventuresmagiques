extends Node3D

var camrot_h = 0
var camrot_v = 0
var cam_v_max = 50
var cam_v_min = -10
var mouse_sensitivity = 0.003
var acceleration = 10

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camrot_h -= event.relative.x * mouse_sensitivity
		camrot_v -= event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	
	$h.rotate_y(camrot_h)
	$h/v.rotate_x(camrot_v)
	$h/v.rotation.x = clamp($h/v.rotation.x, deg_to_rad(-30), deg_to_rad(30))

	camrot_h = 0.0
	camrot_v = 0.0
	#$h.rotation.y = lerp($h.rotation_degrees.y, -camrot_h, acceleration * delta)
	#$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, acceleration * delta)
	#
	
