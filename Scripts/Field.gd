const BLOCKS = preload("Blocks.gd")

var bitmap

func _init():
	bitmap = BitMap.new()
	bitmap.create(Vector2(10*3,18))
	
func checkBlockCollision(block):
	var blockArray = BLOCKS.getBlock(block.getCurrType())[block.getCurrRotation()]
	var result = false
	for y in 4:
		for x in 4:
			if(blockArray[y*4+x] != 0):
				result = result || checkCollision(Vector2(block.getPosition().x + x, block.getPosition().y + y))
	return result
	
func checkCollision(coords):
	var fieldSize = bitmap.get_size()
	fieldSize.x = fieldSize.x / 3
	if(coords.y < 0):
		return false
	if coords.x < 0 || coords.x >= fieldSize.x || coords.y >= fieldSize.y:
		return true
	var result = getCell(coords.x, coords.y) > 0
	return result

func getCell(x, y):
	x = x*3
	var bit0 = bitmap.get_bit(Vector2(x + 0,y))
	var bit1 = bitmap.get_bit(Vector2(x + 1,y))
	var bit2 = bitmap.get_bit(Vector2(x + 2,y))
	var value = int(bit0) * 1 + int(bit1) * 2 + int(bit2) * 4
	return value
	
func setCell(x, y, value):
	x = x*3
	bitmap.set_bit(Vector2(x + 0,y),bool(value%2))
	bitmap.set_bit(Vector2(x + 1,y),(value%4 - 1 > 0))
	bitmap.set_bit(Vector2(x + 2,y),(value - 3 > 0))

func checkLines():
	var refresh = false
	var height = bitmap.get_size().y
	var y = height-1
	var lineArr = []
	while y >= 0:
		if isLineComplete(y):
			lineArr.append(y)
			lowerUpperField(y-1,1)
			y += 1
			refresh = true
		y -= 1
	return lineArr
		
func isLineComplete(lineNum):
	var width = 10
	for x in width:
		if getCell(x, lineNum) == 0:
			return false
	return true
	
func copyFieldLine(source, target):
	var width = 10 * 3
	for x in width:
		var bit = bitmap.get_bit(Vector2(x,source))
		bitmap.set_bit(Vector2(x,target), bit)
		
func lowerUpperField(start, amount):
	var y = start
	while y >= 0:
		copyFieldLine(y, y+amount)
		y -= 1
	
# returns number of removed lines if lines were completed
func putBlock(block):
	var type = block.getCurrType()
	var blockArray = BLOCKS.getBlock(type)[block.getCurrRotation()]
	var offset = block.getPosition()
	for y in 4:
		for x in 4:
			if(blockArray[y*4+x] != 0):
				setCell(offset.x + x, offset.y + y, type)
	return checkLines()
		
