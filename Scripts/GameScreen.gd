extends Node2D

enum STATES {FALLING, PLACEMENT}
const SPEEDS = [2000, 1500, 1200, 1000, 800, 600, 400, 300, 200, 100]
const BLOCKS = preload("Blocks.gd")
const FIELD = preload("Field.gd")
const DELAYER = preload("InputDelayer.gd")

var field
var block
var scoreNode

var fieldOrigin
var blockTypes

var speed = 1
var state = STATES.FALLING
var downDelay
var leftDelay
var rightDelay

var moveTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	field = FIELD.new()
	block = BLOCKS.new()
	scoreNode = get_node("Score/Label")
	
	fieldOrigin = get_node("FieldOrigin")
	initBlockTypes()
	#initDebug()
	clearFieldView()
	refreshFieldView()
	downDelay = DELAYER.new()
	downDelay.init("ui_down", 400, 50)
	leftDelay = DELAYER.new()
	leftDelay.init("ui_left", 300, 50)
	rightDelay = DELAYER.new()
	rightDelay.init("ui_right", 300, 50)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATES.FALLING:
		# Check for automatic movement first
		if block.getCurrType() != BLOCKS.NONE:
			moveTime += delta * 1000
			if(moveTime > SPEEDS[speed]):
				moveBlockDown()
			# Check for user input (rotate/movement)
			if 	downDelay.is_currently_pressed(delta):
				moveBlockDown()
			else: if leftDelay.is_currently_pressed(delta):
				moveBlockSide("left")
			else: if rightDelay.is_currently_pressed(delta):
				moveBlockSide("right")
			else: if Input.is_action_just_pressed("ui_rotate"):
				$rotateSound.play()
				block.rotateForward()
				if(field.checkBlockCollision(block)):
					block.rotateBack()
				else: refreshCurrBlockView("rotation")
			else: if Input.is_action_just_pressed("ui_rotate_alt"):
				$rotateSound.play()
				block.rotateBack()
				if(field.checkBlockCollision(block)):
					block.rotateForward()
				else: refreshCurrBlockView("rotation")
		else: # No block there, do animations
			downDelay.requestReactivation()
			block.setPosition(4,-2)
			block.generate()
			showPreviewBlock()
			refreshCurrBlockView("rotation")
	if state == STATES.PLACEMENT:
		# collision... put block in?
		$placementSound.play()
		var lines = field.putBlock(block)
		if lines > 0:
			var mult = pow(2,lines) - 1
			scoreNode.addPoints(mult * 100)
			
		refreshFieldView()
		var children = get_node("currBlock").get_children()
		for i in children.size():
			children[i].queue_free()
		block.setCurrType(BLOCKS.NONE)
		state = STATES.FALLING
			
func moveBlockDown():
	moveTime = 0
	block.moveDown()
	if field.checkBlockCollision(block):
		block.translate(0,-1)
		state = STATES.PLACEMENT
	refreshCurrBlockView("position")
		
func moveBlockSide(side):
	var oldPos = block.getPosition()
	if side == "left": 
		block.translate(-1, 0)
	else: if side == "right":
		block.translate(1, 0)
	if(field.checkBlockCollision(block)):
		block.setPosition(oldPos.x, oldPos.y)
	refreshCurrBlockView("position")

func refreshCurrBlockView(mode):
	if(mode == "position"):
		var blockPos = block.getPosition()
		get_node("currBlock").position = Vector2(fieldOrigin.position.x + blockPos.x * 32,
										fieldOrigin.position.y + blockPos.y * 32)
	if(mode == "rotation"):
		var currBlockNode = get_node("currBlock")
		var children = get_node("currBlock").get_children()
		for i in children.size():
			children[i].free()
		var prototypeBlock = blockTypes[block.getCurrType()]
		for i in 4:
			currBlockNode.add_child(prototypeBlock.duplicate(0))
		var blockNodes = get_node("currBlock").get_children()
		var index = 0
		var blockPos = block.getPosition()
		currBlockNode.position = Vector2(fieldOrigin.position.x + blockPos.x * 32,
										fieldOrigin.position.y + blockPos.y * 32)
		var blockPattern = BLOCKS.getBlock(block.getCurrType())[block.getCurrRotation()]
		for y in 4:
			for x in 4:
				var type = blockPattern[4*y + x]
				if(type != 0):
					blockNodes[index].position = Vector2(x*32,y*32)
					index += 1

func showPreviewBlock():
		var previewNode = $preview
		var children = previewNode.get_children()
		for i in children.size():
			children[i].free()
			
		var prototypeBlock = blockTypes[block.getPreviewType()]
		for i in 4:
			previewNode.add_child(prototypeBlock.duplicate(0))
		var blockNodes = $preview.get_children()
		var index = 0
		var blockPattern = BLOCKS.getBlock(block.getPreviewType())[0]
		for y in 4:
			for x in 4:
				var type = blockPattern[4*y + x]
				if(type != 0):
					blockNodes[index].position = Vector2(x*32,y*32)
					index += 1

func refreshFieldView():
	clearFieldView()
	for y in range(18):
		for x in range(10):
			var type = field.getCell(x,y)
			if type != 0:
				var child = blockTypes[type].duplicate(0)
				child.name = "block_" + str(x) + "_" + str(y)
				child.position = Vector2(x*32, y*32)
				fieldOrigin.add_child(child)
				
func clearFieldView():
	var childCount = fieldOrigin.get_child_count()
	for i in range(childCount):
		fieldOrigin.get_child(i).queue_free()

func initBlockTypes():
	blockTypes = [self.get_node("BlockTypes/Type1")]
	blockTypes.append(self.get_node("BlockTypes/Type1"))
	blockTypes.append(self.get_node("BlockTypes/Type2"))
	blockTypes.append(self.get_node("BlockTypes/Type3"))
	blockTypes.append(self.get_node("BlockTypes/Type4"))
	blockTypes.append(self.get_node("BlockTypes/Type5"))
	blockTypes.append(self.get_node("BlockTypes/Type6"))
	blockTypes.append(self.get_node("BlockTypes/Type7"))
