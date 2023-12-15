extends CharacterBody3D

@onready var anim_tree = $Mage/AnimationTree
@onready var playback = anim_tree.get("parameters/playback")


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var direction
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#state Variables
var state
var state_factory

func _ready():
	state_factory = StateFactory.new()
	change_state("idle")
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	direction = Vector3(Input.get_action_strength("right") - Input.get_action_strength("left"),
				0,
				Input.get_action_strength("forward") - Input.get_action_strength("backward"))
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#direction = (transform.basis * Vector3(direction.x, 0, direction.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	velocity = direction

	move_and_slide()

func change_state(new_state_name):
	if state != null:
		state.exit()
		state.queue_free()
	#Add aa new state
	state = state_factory.get_state(new_state_name).new()
	state.setup("change_state", playback, self)
	state.name = new_state_name
	add_child(state)
	
	
	
	
