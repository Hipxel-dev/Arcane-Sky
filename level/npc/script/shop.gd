extends Node2D

var shop_entered = false



func _physics_process(delta: float) -> void:
	show_shop(delta)
	if position.distance_squared_to(global.player_pos) < 600:
		if Input.is_action_just_pressed("USE") and shop_entered == false:
			$shopui.current_state = $shopui.shopstate.MAIN
			shop_entered = true
		elif Input.is_action_just_pressed("USE") and shop_entered == true:
#			$shopui.current_state = $shopui.shopstate.NOTACTIVE
			shop_entered = false
	
	
	
	$shopui.current_state = $shopui.shopstate.MAIN
	
		
func show_shop(delta):
	if shop_entered:
		$shopui.show()
		$shopui/char.position /= 1.1
		$shopui/Node2D/buy_ui2.rect_position.y += (-2 - $shopui/Node2D/buy_ui2.rect_position.y) * 0.1
		$shopui/Node2D/buy_ui3.rect_position.y += (165 - $shopui/Node2D/buy_ui3.rect_position.y) * 0.1
	else:
		$shopui/char.position.x = 400
		$shopui.hide()
		$shopui/Node2D/buy_ui2.rect_position.y = -52
		$shopui/Node2D/buy_ui3.rect_position.y = 210
	
#func sprlrp(property, target):
	
	

