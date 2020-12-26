extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("PressAnyButtonAnim")
	pass # Replace with function body.

	
func startGame():
	get_tree().change_scene("res://Screens/GameScreen.tscn")

func mouseOverButton(entered, button):
	var elem = null
	match(button):
		"Start":
			elem = get_node("Startmenu/VBoxContainer/Start")
			
	var color
	if entered:
		color = Color(0.234467, 0.207882, 0.591309)
	else:
		color = Color(1,1,1,1)
	elem.set("custom_colors/font_color", color)

func _on_Start_gui_input(event):
	if event.get_class() == "InputEventMouseButton":
		if(event.button_index == 1 && !event.pressed):
			get_tree().change_scene("res://Screens/GameScreen.tscn")
	pass # Replace with function body.

func _unhandled_key_input(event):
	if(state == 0):
		$AnimationPlayer.queue_free()
		$startScreen/pressAnyButton.queue_free()
		state = 1
		get_tree().change_scene("res://Screens/GameScreen.tscn")
