extends CharacterBody3D


var movement_speed := 0.0
var run_speed := 100
var walk_speed := 60
var acceleration := 6
var jump_magnitude := 15.0
var vertical_velocity := 0.0
var gravity := 28.0
var angular_acceleration := 7

var direction := Vector3.FORWARD
var strafe_dir := Vector3.ZERO
var strafe := Vector3.ZERO

var sprint_toggle := true
var sprinting := false

func _input(event):
	if sprint_toggle:
		if event.is_action_pressed("sprint"):
			sprinting = false if sprinting else true
	else:
		sprinting = Input.is_action_pressed("sprint")
	
	if Input.is_key_pressed(KEY_1):
		sprint_toggle = false if sprint_toggle else true


func _physics_process(delta):
	velocity = Vector3.ZERO
	if Input.is_action_pressed("aim"):
		$AnimationTree["parameters/aim_transition/transition_request"] = "aiming"
	else:
		$AnimationTree["parameters/aim_transition/transition_request"] = "not_aiming"
	
	var h_rot = $camroot/h.global_transform.basis.get_euler().y
	
	if Input.is_action_pressed("forward")||Input.is_action_pressed("backward")||Input.is_action_pressed("left")||Input.is_action_pressed("right"):
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
						0,
						Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		
		strafe_dir = direction
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		
		if sprinting && $AnimationTree.get("parameters/aim_transition/current_state") == "not_aiming":
			movement_speed = run_speed
			$AnimationTree["parameters/iwr_blend/blend_amount"] = lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), 1.0, delta * acceleration)
		else:
			movement_speed = walk_speed
			$AnimationTree["parameters/iwr_blend/blend_amount"] = lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), 0.0, delta * acceleration)
	else:
		movement_speed = 0
		$AnimationTree["parameters/iwr_blend/blend_amount"] = lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), -1.0, delta * acceleration)
		strafe_dir = Vector3.ZERO
		
		if $AnimationTree.get("parameters/aim_transition/current_state") == "aiming":
			direction = $camroot/h.global_transform.basis.z

	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)
	velocity = velocity + Vector3.UP * vertical_velocity
	move_and_slide()
	
	if !is_on_floor():
		vertical_velocity -= gravity * delta
	else:
		vertical_velocity = 0
	
	if $AnimationTree.get("parameters/aim_transition/current_state") == "not_aiming":
		$Mage.rotation.y = lerp_angle($Mage.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	else:
		$Mage.rotation.y = lerp_angle($Mage.rotation.y, h_rot, delta * angular_acceleration)
		
	strafe = lerp(strafe, strafe_dir, delta * acceleration)
	
	$AnimationTree["parameters/strafe/blend_position"] = Vector2(-strafe.x, strafe.z)
	velocity = direction
	
	if Input.is_action_just_pressed("fire"):
		$AnimationTree["parameters/throw/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	if is_on_floor():
		$AnimationTree["parameters/jump_transition/transition_request"] = "not_jumping"
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_magnitude
			$AnimationTree["parameters/jump_transition/transition_request"] = "jumping"
			$AnimationTree["parameters/JumpStateMachine/playback"].travel("Jump_Start")
			
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("left", "right", "forward", "backward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#direction = direction.rotated(Vector3.UP, h_rot).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
