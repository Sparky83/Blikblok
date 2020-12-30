extends Node

enum {BLINK, MENU, LOAD, NEW}

var state = BLINK

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("PressAnyButtonAnim")
	Global.readScores()
	
func startGame():
	if !get_tree().change_scene("res://Screens/GameScreen.tscn"):
		print("Error changing scenes")

func mouseOverButton(entered, button):
	var elem = null
	match(button):
		"Start":
			elem = get_node("Startmenu/NinePatchRect/VBoxContainer/Start")
		"Quit":
			elem = get_node("Startmenu/NinePatchRect/VBoxContainer/Quit")
		"Scores":
			elem = get_node("Startmenu/NinePatchRect/VBoxContainer/Scores")
	var color
	if entered:
		color = Color(0.234467, 0.207882, 0.591309)
	else:
		color = Color(1,1,1,1)
	elem.set("custom_colors/font_color", color)

func _unhandled_key_input(event):
	if(state == BLINK):
		$AnimationPlayer.queue_free()
		$startScreen/pressAnyButton.queue_free()
		state = 1
		$Startmenu/NinePatchRect/AnimationPlayer.play("Show")
		$Startmenu.visible = true
		var tween = Tween.new()
		$titletext.add_child(tween)
		tween.interpolate_property($titletext, "position",
				Vector2(640,320), Vector2(640, 175), 1,
				Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		tween.start()
		
