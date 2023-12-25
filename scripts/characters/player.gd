extends CharacterBody3D

@onready var interaction_raycast = $Mage/interactionRaycast
@onready var hand = $Mage/hand
@onready var throw_audio_stream_player = $ThrowAudioStreamPlayer


var movement_speed := 0.0
var run_speed := 85
var walk_speed := 60
var acceleration := 6
var jump_magnitude := 12.0
var vertical_velocity := 0.0
var gravity := 28.0
var angular_acceleration := 7

var direction := Vector3.FORWARD
var strafe_dir := Vector3.ZERO
var strafe := Vector3.ZERO

var jumping := false
var last_floor := true

var sprint_toggle := true
var sprinting := false

var push_force := 25.0
var push_factor := 0.0

var picked_object
var pull_power := 5

@onready var shoot_timer = $Shoot_Timer
var can_shoot := true
@onready var muzzle = $Mage/muzzle
var bullet = load("res://scenes/mechanics/bullet_lighning.tscn")
var instance

func _ready():
	Global.on_pause_mode.connect(pausing)

func _input(event):
	if sprint_toggle:
		if event.is_action_pressed("sprint"):
			sprinting = false if sprinting else true
	else:
		sprinting = Input.is_action_pressed("sprint")
	
	if Input.is_action_just_pressed("toggle_sprint"):
		sprint_toggle = false if sprint_toggle else true

	if event.is_action_pressed("interact"):
		if picked_object == null:
			print("NO OBJ")
			pick_object()
		elif picked_object != null:
			release_object()
	if event.is_action_pressed("BMM"):
		if picked_object !=null:
			throw_object()
			release_object()

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
	
	##handle interaction with rigidbodies#################
	push_factor = velocity.length()
	push_factor = clamp(push_factor, 1.5, 10)
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force * push_factor)
	###########################
	
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
	
	#SHOOTING		
	if Input.is_action_just_pressed("fire"):
		if can_shoot:
			fire()
			$ShootAudioStreamPlayer.play()
			$AnimationTree["parameters/throw/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	#JUMPING
	if is_on_floor():
		$AnimationTree["parameters/jump_transition/transition_request"] = "not_jumping"
		if Input.is_action_just_pressed("jump"):
			jumping = true
			vertical_velocity = jump_magnitude
			$AnimationTree["parameters/jump_transition/transition_request"] = "jumping"
			$AnimationTree["parameters/JumpStateMachine/playback"].travel("Jump_Start")
	if is_on_floor() and not last_floor:
		jumping = false
		$AnimationTree["parameters/jump_transition/transition_request"] = "not_jumping"
	if not is_on_floor() and not jumping:
		$AnimationTree["parameters/JumpStateMachine/playback"].travel("Jump_Idle")
		$AnimationTree["parameters/jump_transition/transition_request"] = "jumping"
	last_floor = is_on_floor()
	
	####### HANDLING PICKED OBJECT ################
	
	if picked_object != null:
		picked_object.add_highlight()
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a) * pull_power)
	#################################################
		
func fire():
	can_shoot = false
	instance = bullet.instantiate()
	instance.position = muzzle.global_position
	instance.transform.basis = muzzle.global_transform.basis
	get_parent().add_child(instance)
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true

func damage_received():
	if Global.health >= 0:
		Global.health -= 5
		Global.emit_health_update()

func pick_object() -> void:
	var collider = interaction_raycast.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider

func release_object() -> void:
	if picked_object != null:
		picked_object.remove_highlight()
		picked_object = null
	
func throw_object() -> void:
	var knockback = picked_object.position - position
	picked_object.apply_central_impulse(knockback * 200)
	release_object()
	throw_audio_stream_player.play()
	
func pausing(on):
	set_physics_process(!on)
	
