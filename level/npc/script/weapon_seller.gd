extends Node2D

var cost = 250
var section_index = 1
var last_section_index = 1
var last_section_since_player_exited = -1

var scroll = 1
var circs = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

func _ready() -> void:
	$shop_ui/ColorRect/gradient.show()
	$shop_ui/ColorRect/gradient2.show()
	$shop_ui/ColorRect/gradient3.show()

func _draw() -> void:
	pass
#	if $shop_ui/weapon_shop_ui.active:
#		if circs[circs.size() - 1] > 19:
#			circs.pop_back()
#			circs.insert(0, 0)
#
#		for i in range(circs.size()):
#			circs[i] += scroll
#		for i in circs:
#			draw_arc($shop_ui.offset, i * 32, -PI - 0.1, PI + 0.1, 360, Color8(55,55,55), 16)
		
func _physics_process(delta: float) -> void:
	scroll = delta
		
		
	if section_index == 0:
		$shop_ui/selection_ui/magic_shop_selection.scale = Vector2(1,1)
		$shop_ui/selection_ui.position.x += 50
	else:
		$shop_ui/selection_ui/magic_shop_selection.scale = Vector2(0.5,0.5)
	if section_index == 1:
		$shop_ui/selection_ui/weapon_shop_select.scale = Vector2(1,1)
	else:
		$shop_ui/selection_ui/weapon_shop_select.scale = Vector2(0.5,0.5)
	if section_index == 2:
		$shop_ui/selection_ui/ammo_shop_select.scale = Vector2(1,1)
		$shop_ui/selection_ui.position.x -= 50
	else:
		$shop_ui/selection_ui/ammo_shop_select.scale = Vector2(0.5, 0.5)
	
	$shop_ui/selection_ui.position.x += (240 - $shop_ui/selection_ui.position.x) * 0.15
	
	$shop_ui.offset += (get_local_mouse_position() / -15 - $shop_ui.offset) * 0.07
	
	if last_section_index != section_index:
		fx.spwn_sound(preload("res://sound/player/ui_sfx/click1.wav"))
		last_section_index = section_index
	
	if global.player_pause:
		if Input.is_action_just_pressed("LEFT"):
			if section_index > 0:
				section_index -= 1
			else:
				section_index = 2
		if Input.is_action_just_pressed("RIGHT"):
			if section_index < 2:
				section_index += 1
			else:
				section_index = 0
		
	if global.player_pos.x < position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1
		
	if section_index == -1:
		$shop_ui.hide()
	else:
		$shop_ui.show()
	
	if $shop_ui/weapon_shop_ui.active == false and $shop_ui/weapon_shop_ui.ui_buttons:
		for i in $shop_ui/weapon_shop_ui.ui_buttons:
			i.queue_free()
		$shop_ui/weapon_shop_ui.ui_buttons.clear()
		$shop_ui/weapon_shop_ui.init = true
	if position.distance_squared_to(global.player_pos) < 1600:
		if Input.is_action_just_pressed("USE"):
			$shop_ui/weapon_shop_ui.active = !$shop_ui/weapon_shop_ui.active
			global.player_pause = $shop_ui/weapon_shop_ui.active
			$shop_ui.visible = $shop_ui/weapon_shop_ui.active
			var p = get_tree().get_nodes_in_group("p")[0]
			p.get_node("UI").visible = !$shop_ui/weapon_shop_ui.active
			if not global.player_pause:
				p.showui()
				p.movement = Vector2.ZERO
				p.reset_physics_interpolation()
				last_section_since_player_exited = section_index
				section_index = -1
			else:
				p.hideui()
				section_index = last_section_since_player_exited
			yield(get_tree().create_timer(0.06), "timeout")
			get_tree().paused = $shop_ui/weapon_shop_ui.active
			 
			
	elif Input.is_action_just_pressed("USE"):
		var p = get_tree().get_nodes_in_group("p")[0]
		p.showui()
		$shop_ui/weapon_shop_ui.active = false
		global.player_pause = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		var p = get_tree().get_nodes_in_group("p")[0]
		p.showui()
		$shop_ui/weapon_shop_ui.active = false
		global.player_pause = false
	update()
	if $shop_ui/weapon_shop_ui.active:
		
		z_index = 5
		$shop_ui/ColorRect.modulate = $shop_ui/ColorRect.modulate.linear_interpolate(Color.white, delta * 5)
	else:
		z_index = 0
		$shop_ui/ColorRect.modulate = $shop_ui/ColorRect.modulate.linear_interpolate(Color.transparent, delta * 8)
