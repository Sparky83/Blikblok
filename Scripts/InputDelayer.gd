
var actionName
var delay
var offset

var time = 0
var isPressed = false
var lastPress = 0
var request_reactivation = false

func init(action, initdelay, offsetdelay):
	actionName = action
	delay = initdelay
	offset = offsetdelay
	
func is_currently_pressed(delta):
	isPressed = Input.is_action_pressed(actionName)
	if !isPressed:
		request_reactivation = 0
		time = 0
		return false
	else:
		if time == 0:
			time = 1
			lastPress = offset
			return true
		else:
			time = time + delta * 1000
			lastPress = lastPress + delta * 1000
			
		if time >= delay && lastPress >= offset && !request_reactivation:
			lastPress = 0
			return true
		else: return false

func requestReactivation():
	request_reactivation = true
