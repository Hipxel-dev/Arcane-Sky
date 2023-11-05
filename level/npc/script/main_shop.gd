extends Node2D

var active = true

onready var button = [$resources, $upgrades, $buffs]
var btn_spr = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

var last_index = 0
var index = 0

var slct_size_scale_spr = 0
var slct_size_scale = 1
var size = 16


func _physics_process(delta: float) -> void:
	if active:
		$title_rect.rect_position.y += (21 - $title_rect.rect_position.y) * 0.1
		position /= 1.1
		for i in range(button.size()):
			btn_spr[i] = lerp(btn_spr[i], (Vector2(50 * (i + 1), 100) - button[i].position) * 0.5, 0.2)
			
			button[i].position += btn_spr[i]
			
			if i != index:
				button[i].get_node("outline").hide()
				button[i].get_node("outline").margin_left = -20
				button[i].get_node("outline").margin_top = -21
				button[i].get_node("outline").margin_right = 25
				button[i].get_node("outline").margin_bottom = 24
				
				
			if get_local_mouse_position().x > (button[i].position.x - size) and get_local_mouse_position().x < (button[i].position.x + size) and get_local_mouse_position().y > (button[i].position.y - size) and get_local_mouse_position().y < (button[i].position.y + size):
				index = i
				
			if not get_local_mouse_position().x > (button[i].position.x - size) and not get_local_mouse_position().x < (button[i].position.x + size) and not get_local_mouse_position().y > (button[i].position.y - size) and not get_local_mouse_position().y < (button[i].position.y + size):
				index = 0
				
		var btn = button[index]
		
		btn.position.y += -3
		btn.get_node("outline").show()
		btn.get_node("outline").margin_left = -20 
		btn.get_node("outline").margin_top = -21 
		btn.get_node("outline").margin_right = 25 
		btn.get_node("outline").margin_bottom = 24
		
		slct_size_scale_spr = lerp(slct_size_scale_spr, (1 - slct_size_scale) * 0.5, 0.3)
		slct_size_scale += slct_size_scale_spr
		
		$select_fx.scale = Vector2(1,1) * slct_size_scale
		$select_fx.position += (btn.position - $select_fx.position) * 0.3
		$select_fx.modulate = btn.get_node("rect").color
		
		if Input.is_action_just_pressed("CLICK") or Input.is_action_just_pressed("ui_accept"):
			btn.position.y -= 10
			if index == 0:
				shopui.current_state = shopui.shopstate.NOTACTIVE
			if index == 1:
				get_parent().current_state = get_parent().shopstate.UPGRADES
			if index == 2:
				get_parent().current_state = get_parent().shopstate.BUFF
		
		if last_index != index:
			slct_size_scale = 0.5
			last_index = index
		
	else:
		position.y += (-320 - position.y) * 0.16
		$title_rect.rect_position.y = -20
		for i in range(button.size()):
			button[i].position.x = -10 
			button[i].position.y = 170
	
