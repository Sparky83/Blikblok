# Global operations
extends Node

const KEYVALUE = preload("KeyValue.gd")

var scores = []
var newScore = -1

var saveFilePath = "user://save_game.dat"
var pwd = "somePassword"
var scoresRead = false

func debugScores():
	for score in scores:
		print(score.getKey())

func readScores():
	if(!scoresRead):
		scoresRead = true
		scores.clear()
		var file = File.new()
		file.open(saveFilePath, File.READ)
		while(!file.eof_reached()):
			var entry = KEYVALUE.new()
			var line = file.get_line()
			if line.find(";") != -1:
				var values = line.split(";")
				entry.setPair(values[0], int(values[1]))
				scores.append(entry)
		file.close()

func saveScores():
	var file = File.new()
	file.open(saveFilePath, File.WRITE)
	for score in scores:
		print(score.getKey())
		file.store_line(score.getKey() + ";" + str(score.getValue()))
	print("Saved scores")
	file.close()

func sortScores():
	scores.sort_custom(self, "scoreSortingFunc")

func scoreSortingFunc(a, b):
	if(a.getValue() > b.getValue()):
		return true
	return false

func checkNewScore():
	if(newScore > 0):
		if(scores.size() < 10 || scores.back().getValue() < newScore):
			return true
	return false

func addScore(name, score):
	var entry = KEYVALUE.new()
	if score == -1:
		score = newScore
	entry.setPair(name, score)
	scores.append(entry)
	newScore = -1
	sortScores()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		saveScores()
		get_tree().quit() # default behavior
