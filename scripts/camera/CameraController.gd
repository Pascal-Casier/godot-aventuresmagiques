extends Node3D

var sensitivity = 5
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	global_position = $"..".global_position
	
func _input(event):
	if event is InputEventMouseMotion:
		var xRot = clamp(rotation.x - event.relative.y / 1000 * sensitivity, -0.5, 0.5)
		var yRot = rotation.y - event.relative.x / 1000 * sensitivity
		rotation = Vector3(xRot, yRot, 0)

	if event is InputEventMouseButton:
		if event.button_index == 5:
			if $SpringArm3D.spring_length < 10:
				$SpringArm3D.spring_length += 0.2
		if event.button_index == 4:
			if $SpringArm3D.spring_length >2:
				$SpringArm3D.spring_length -= 0.2
