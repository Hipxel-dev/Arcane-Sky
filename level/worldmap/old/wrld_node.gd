extends Node2D

var hovered = false
var just_hovered = false
var selected = false

var original_pos = Vector2.ZERO

var child = []
var parent = null

var tex = preload("res://art/player_art/ui_art/general_ui_art/pixel_shd.png")

var cam_zoom = 1
var scrolling = 1
var rotation_scroll = 1

var unlocked = false 
var child_unlocked = false
var parent_unlocked = false

var progress_inducing = false

export var node_name = "The Glens"
export var node_desc = "Insert level desc here"
var level_to_load = load("res://level/level_manager.tscn")

var circ_step = 15
var step = 10 
var sin_vel = 0

var circ_radius = 16

func _ready() -> void:
	scale = Vector2(10,10) * 100
	original_pos = global_position
	
	for i in get_children():
		if i.is_in_group("wrld_node") and i.get_parent() == self:
			child.append(i)
			
	if get_parent().is_in_group("wrld_node"):
		parent = get_parent()
	else:
		parent = self

func _draw() -> void:
	if unlocked:
		
		for i in range(28):
			var angle = PI + i * (circ_step - 10)
			draw_texture(tex, 
			Vector2(sin(angle + circ_radius + rotation_scroll), cos(angle + circ_radius + rotation_scroll)) * circ_radius
			,$sprite.modulate
			)
		
	for i in child:
		
		var color = Color8(255,255,255,255)
		
		if child_unlocked:
			color = Color8(255,255,255)
#			modulate = Color(1,1,1,1)
		else:
#			modulate = Color(1,1,1,0.9)
			color = Color8(0, 50, 87)
		
		var target_pos = i.position
		
		step = 15 - (cam_zoom * 7)
		if not child_unlocked:
			step = 7
		
		for o in range(target_pos.length() / step):
			var col = sin(o) * 255
			draw_texture(tex, (target_pos.normalized() * (o * step + scrolling)), color) 
	
func _physics_process(delta: float) -> void:
	update()
	
	rotation_scroll -= 0.1
	
	for i in child:
		if i.unlocked:
			child_unlocked = true
		else:
			child_unlocked = false
			
	if parent.unlocked:
		parent_unlocked = true
	else:
		parent_unlocked = false
	
	if unlocked:
		$sprite.modulate = Color.cyan
	else:
		$sprite.modulate = Color8(0, 50, 87)
	
	progress_inducing = false
	
	
	if child_unlocked:
		scrolling += 0.5
		if scrolling >= step:
			scrolling = 0
	scale = scale.linear_interpolate(Vector2(1,1), delta * 3)
	
	global_position = original_pos
	
	if selected:
		$select_fx.modulate = $sprite.modulate
		$select_fx.position = Vector2(sin(rotation_scroll), cos(rotation_scroll)) * 33
		$select_fx.emitting = true
		circ_radius += (32 - circ_radius) * 0.2
		$sprite.scale = $sprite.scale.linear_interpolate(Vector2(1, 1), delta * 10)
		$sprite/light.scale += (Vector2(0.2, 0.2) - $sprite/light.scale) * 0.3
		
	else:
		$select_fx.emitting = false
		
	if hovered:
		if just_hovered == false:
			circ_radius = 32
			just_hovered = true
#			fx.spwn_trail_phys(global_position)
			fx.spwn_sound(preload("res://sound/player/ui_sfx/orb_spawn.wav"), global.player_pos, -0, 3)
			fx.spwn_sound(preload("res://sound/player/ui_sfx/orb_spawn.wav"), global.player_pos, -0, 7)
			fx.spwn_sound(preload("res://sound/player/ui_sfx/click1.wav"), global.player_pos, 1, 2)
#			fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -10, 0.3)
#			fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -5, 1.5)
			$sprite/light.scale = Vector2(0.8,0.8)
		
		
		circ_radius += (16 - circ_radius) * 0.2
		$sprite.scale = $sprite.scale.linear_interpolate(Vector2(1, 1), delta * 10)
		$sprite/light.scale += (Vector2(0.2, 0.2) - $sprite/light.scale) * 0.3
		
		if Input.is_action_just_pressed("CLICK"):
			$sprite.scale = Vector2(3,3)
			step = 0
			circ_radius = -64
			for i in range(15):
				fx.spwn_trail_phys(global_position)
				fx.spwn_particle_trail(global_position, Vector2(rand_range(-1000,1000),rand_range(-1000,1000)), $sprite.modulate)
		
	else:
		circ_radius /= 1.1
		just_hovered = false
		if unlocked:
			$sprite/light.scale += (Vector2(0.15, 0.15) * sin((OS.get_ticks_msec() + sin_vel) * delta * 0.2) * 1 - $sprite/light.scale) * 0.5
		else:
			$sprite/light.scale = Vector2(0.15, 0.15) 
		$sprite.scale = $sprite.scale.linear_interpolate(Vector2(0.5, 0.5), delta * 10)
	
#	$sprite.position.y /= 1.5
