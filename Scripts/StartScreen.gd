extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	initButton()
	pass # Replace with function body.


func initButton():
	var button = Button.new()
	button.text = "Start Game"
	button.connect("pressed", self, "startGame")
	add_child(button)
	pass # does nothing
	
func startGame():
	get_tree().change_scene("res://Screens/GameScreen.tscn")
