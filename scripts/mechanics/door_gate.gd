extends Node3D

@export var door_nbr: int = 0
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer
var is_open := false

func _ready():
	Global.open_door_gate.connect(open_door)


func open_door(nbr):
	if nbr == door_nbr and !is_open:
		animation_player.play("open")
		audio_stream_player.play()
		is_open = true
		
