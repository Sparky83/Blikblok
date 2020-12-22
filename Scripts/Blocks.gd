
enum {
	NONE,
	NORMAL_L,
	MIRRORED_L,
	NORMAL_S,
	MIRRORED_S,
	QUAD,
	LONG,
	TRIANGLE
}

var blockPos
var currType = 0
var currRotation = 0

static func getBlock(type):
	var posArray
	match type:
		NORMAL_L:
			posArray = [[0,0,0,0, 0,0,0,0, 1,1,1,0, 1,0,0,0],
						[0,0,0,0, 0,1,0,0, 0,1,0,0, 0,1,1,0],
						[0,0,0,0, 0,0,0,0, 0,0,1,0, 1,1,1,0],
						[0,0,0,0, 1,1,0,0, 0,1,0,0, 0,1,0,0]]
		MIRRORED_L:
			posArray = [[0,0,0,0, 0,0,0,0, 1,1,1,0, 0,0,1,0],
						[0,0,0,0, 0,1,1,0, 0,1,0,0, 0,1,0,0],
						[0,0,0,0, 0,0,0,0, 1,0,0,0, 1,1,1,0],
						[0,0,0,0, 0,1,0,0, 0,1,0,0, 1,1,0,0]]
		NORMAL_S:
			posArray = [[0,0,0,0, 0,0,0,0, 0,1,1,0, 1,1,0,0],
						[0,0,0,0, 1,0,0,0, 1,1,0,0, 0,1,0,0],
						[0,0,0,0, 0,0,0,0, 0,1,1,0, 1,1,0,0],
						[0,0,0,0, 1,0,0,0, 1,1,0,0, 0,1,0,0]]
		MIRRORED_S:
			posArray = [[0,0,0,0, 0,0,0,0, 1,1,0,0, 0,1,1,0],
						[0,0,0,0, 0,1,0,0, 1,1,0,0, 1,0,0,0],
						[0,0,0,0, 0,0,0,0, 1,1,0,0, 0,1,1,0],
						[0,0,0,0, 0,1,0,0, 1,1,0,0, 1,0,0,0]]
		QUAD:
			posArray = [[0,0,0,0, 0,0,0,0, 0,1,1,0, 0,1,1,0],
						[0,0,0,0, 0,0,0,0, 0,1,1,0, 0,1,1,0],
						[0,0,0,0, 0,0,0,0, 0,1,1,0, 0,1,1,0],
						[0,0,0,0, 0,0,0,0, 0,1,1,0, 0,1,1,0]]
		LONG:
			posArray = [[0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0],
						[0,1,0,0, 0,1,0,0, 0,1,0,0, 0,1,0,0],
						[0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0],
						[0,1,0,0, 0,1,0,0, 0,1,0,0, 0,1,0,0]]
		TRIANGLE:
			posArray = [[0,0,0,0, 0,0,0,0, 1,1,1,0, 0,1,0,0],
						[0,0,0,0, 0,1,0,0, 0,1,1,0, 0,1,0,0],
						[0,0,0,0, 0,1,0,0, 1,1,1,0, 0,0,0,0],
						[0,0,0,0, 0,1,0,0, 1,1,0,0, 0,1,0,0]]
	return posArray

func getCurrType():
	return currType
	
func setCurrType(type):
	currType = type
	
func getCurrRotation():
	return currRotation
	
func setCurrRotation(rot):
	currRotation = rot%4
	
func rotateForward():
	setCurrRotation(currRotation + 1)
	
func rotateBack():
	setCurrRotation(currRotation + 3)

func getPosition():
	return blockPos
	
func setPosition(x, y):
	blockPos = Vector2(x,y)
	
func translate(x, y):
	blockPos = blockPos + Vector2(x,y)
	
func moveDown():
	translate(0,1)

func generate():
	currRotation = 0
	var randGen = RandomNumberGenerator.new()
	randGen.randomize()
	currType = randGen.randi_range(1,7)
	return currType
	
	
