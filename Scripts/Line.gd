extends Node2D

const BLOCK_SCENE = preload("res://Prefabs/Block.tscn")

var blockList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in 10:
		var block = BLOCK_SCENE.instance()
		block.position = Vector2(x*32,0)
		block.name = "Block" + str(x)
		addBlock(block)

func addBlock(block):
	add_child(block)
	if(!blockList.empty()):
		var prev = blockList.back()
		prev.setNext(block)
	blockList.append(block)
	
func explode():
	blockList[0].playAnim()
	
func isExplosionFinished():
	return blockList[-1].isExploded()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
