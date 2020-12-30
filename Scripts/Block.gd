extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animPlayer = null
var next = null
var propagated = false
var exploded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer = $block/fade
	pass # Replace with function body.

func playAnim():
	animPlayer.play("fadeout")
	
func setNext(n):
	next = n
	
func getNext():
	return next
	
func _process(delta):
	if(animPlayer.is_playing() && !propagated):
		var length = animPlayer.current_animation_length
		var dlt = animPlayer.current_animation_position / length
		if dlt >= 0.2:
			if next != null:
				next.playAnim()
				propagated = true
				
func isExploded():
	return exploded

func _onAnimFinished(anim_name):
	if next == null:
		exploded = true

func reset():
	propagated = false
	exploded = false
	set("visibility/modulate", 1.0)
