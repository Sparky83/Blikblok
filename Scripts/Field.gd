extends Node2D

const BLOCKS = preload("Blocks.gd")
const LINE_SCENE = preload("res://Prefabs/Line.tscn")

var bitmap
var explosions = []

func _ready():
	initLines()
	bitmap = BitMap.new()
	bitmap.create(Vector2(10*3,18))
	
func initLines():
	var linesNode = $Lines
	for y in 18:
		var line = LINE_SCENE.instance()
		line.name = "Line%02d" % y
		line.position = Vector2(0,y*32)
		linesNode.add_child(line)
	

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
	if coords.x < 0 || coords.x >= fieldSize.x || coords.y >= fieldSize.y:
		return true
	var result = getCell(coords.x, coords.y) > 0
	return result

func getCell(x, y):
	x = x*3
	if(y < 0 || y >= bitmap.get_size().y):
		return 0
	if(x < 0 || x > bitmap.get_size().x):
		return 1
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
	var lineArr = []
	for y in height:
		if isLineComplete(y):
			lineArr.append(y)
			startExplosion(y)
			lowerUpperField(y-1,1)
			refresh = true
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
	for x in 10:
		setCell(x, 0, BLOCKS.NONE)
		
func putBlock(block):
	var type = block.getCurrType()
	var blockArray = BLOCKS.getBlock(type)[block.getCurrRotation()]
	var offset = block.getPosition()
	for y in 4:
		for x in 4:
			if(blockArray[y*4+x] != 0):
				setCell(offset.x + x, offset.y + y, type)
	
func startExplosion(y):
	var lineName = "Line%02d" % y
	var lineNode = get_node("Lines/" + lineName)
	lineNode.explode()
	explosions.append(lineNode)
	
func isExplosionFinished():
	for index in explosions.size():
		if(!explosions[index].isExplosionFinished()):
			return false
		else:
			explosions.remove(index)
			return isExplosionFinished() # Array was modified, check again
	return true
	
func refreshView():
	clearView()
	for y in range(18):
		for x in range(10):
			var type = getCell(x,y)
			if type != 0:
				# set color here
				var lineNode = get_node("Lines/Line%02d" % y)
				var blockNode = lineNode.get_node("Block" + str(x))
				blockNode.visible = true
				blockNode.set("modulate", Color(BLOCKS.COLORS[type]))
				
func clearView():
	for line in $Lines.get_children():
		for block in line.get_children():
			block.reset()
			block.visible = false
