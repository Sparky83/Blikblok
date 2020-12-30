extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	fillScores()
	var isHighscore = Global.checkNewScore()
	if isHighscore:
		var name = showInputField()

func showInputField():
	$Control/PopupDialog.show_modal(true)

func fillScores():
	var names = ""
	var values = ""
	for entry in Global.scores:
		names = names + " " + entry.getKey() + "\n"
		values = values + " " + str(entry.getValue()) + "\n"
	$Control/Names.set("text", names)
	$Control/Scores.set("text", values)

func _on_Button_pressed():
	var name = $Control/PopupDialog/LineEdit.text
	Global.addScore(name, -1)
	$Control/PopupDialog.hide()
	fillScores()
