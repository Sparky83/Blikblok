extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animPlayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer = $block/fade
	pass # Replace with function body.

func playAnim():
	animPlayer.current_animation_position = 0
	animPlayer.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _onAnimFinished(anim_name):
	self.queue_free()
