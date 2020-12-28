extends Node2D

enum STATES {FALLING, PLACEMENT, REMOVAL}
const SPEEDS = [2000, 1500, 1200, 1000, 800, 600, 400, 300, 200, 100]
const BLOCKS = preload("Blocks.gd")
const FIELD = preload("Field.gd")
const DELAYER = preload("InputDelayer.gd")

var field
var block
var scoreNode

var animOrigin
var fieldOrigin
var blockTypes

var speed = 1
var state = STATES.FALLING
var downDelay
var leftDelay
var rightDelay
var lastPosition = Vector2(0,0)
var samePositionCounter = 0

var moveTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	field = $Field
	block = BLOCKS.new()
	scoreNode = get_node("Score/Label")
	
	fieldOrigin = get_node("Field")
	animOrigin = $AnimOrigin
	initBlockTypes()
	#initDebug()
	field.clearView()
	field.refreshView()
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
				block.rotateBack()
				if(field.checkBlockCollision(block)):
					block.rotateForward()
				else: refreshCurrBlockView("rotation")
			else: if Input.is_action_just_pressed("ui_rotate_alt"):
				$rotateSound.play()
				block.rotateForward()
				if(field.checkBlockCollision(block)):
					block.rotateBack()
				else: refreshCurrBlockView("rotation")
		else: # No block there, do animations
			downDelay.requestReactivation()
			block.setPosition(4,-2)
			block.generate()
			showPreviewBlock()
			refreshCurrBlockView("rotation")
	if state == STATES.PLACEMENT:
		$placementSound.play()
		# put Block
		field.putBlock(block)
		field.refreshView()
		# clear current Block view
		var children = get_node("currBlock").get_children()
		for i in children.size():
			children[i].queue_free()
		# clear current Block data
		block.setCurrType(BLOCKS.NONE)
		# check if lines complete
		var lineArr = field.checkLines()
		var lines = lineArr.size()
		state = STATES.FALLING
		if lines > 0:
			if(lines == 4):
				$quadLineSound.play()
			var mult = pow(2,lines) - 1
			scoreNode.addPoints(mult * 100)
			state = STATES.REMOVAL
	if state == STATES.REMOVAL:
		if field.isExplosionFinished():
			field.refreshView()
			state = STATES.FALLING
		pass
			
func moveBlockDown():
	moveTime = 0
	block.moveDown()
	if field.checkBlockCollision(block):
		block.translate2(0,-1)
		state = STATES.PLACEMENT
		if lastPosition == block.getPosition():	
			samePositionCounter += 1
			if(samePositionCounter >= 4):
				samePositionCounter = 0
				get_tree().change_scene("res://Screens/StartScreen.tscn")
		lastPosition = block.getPosition()
	else:
		samePositionCounter = 0
	refreshCurrBlockView("position")
		
func moveBlockSide(side):
	var oldPos = block.getPosition()
	if side == "left": 
		block.translate2(-1, 0)
	else: if side == "right":
		block.translate2(1, 0)
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

func initBlockTypes():
	blockTypes = [self.get_node("BlockTypes/Type1")]
	blockTypes.append(self.get_node("BlockTypes/Type1"))
	blockTypes.append(self.get_node("BlockTypes/Type2"))
	blockTypes.append(self.get_node("BlockTypes/Type3"))
	blockTypes.append(self.get_node("BlockTypes/Type4"))
	blockTypes.append(self.get_node("BlockTypes/Type5"))
	blockTypes.append(self.get_node("BlockTypes/Type6"))
	blockTypes.append(self.get_node("BlockTypes/Type7"))
