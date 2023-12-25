extends StaticBody3D

@onready var labels = $Cube_Default/labels
@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer
@onready var lbl_phonetic = $lblPhonetic

@export var letter : String = "A"
@export var phonetic : String = "[A]"
@export var letter_audio : AudioStream


func _ready():
	audio_stream_player.stream = letter_audio
	lbl_phonetic.text = phonetic
	for l in labels.get_children():
		l.text = letter


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		animation_player.play("entered")
		audio_stream_player.play()
		lbl_phonetic.show()
		


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		lbl_phonetic.hide()
