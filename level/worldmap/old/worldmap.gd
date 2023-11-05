extends Node2D


onready var cam = $Camera2D
var scroll_y = 0
var scroll_x = 0

var zoom = 1

var wrld_node = preload("res://level/worldmap/wrld_node.tscn")

onready var closest_node = $world_canvas/world_node
var closest_node_distance = INF

var hover_dist = 1000
onready var selection_box = $selection_box

var pan_pos = Vector2.ZERO
var cam_pan_pos = Vector2.ZERO
var pan_strength = 100

var m_right = 0
var m_left = 0
var m_down = 0
var m_up = 0

var margin_scale = 1

var just_selected_a_node = false
var just_deselected_a_node = false


onready var progress_inducing_node_array = [$world_canvas/world_node]
onready var progress_inducing_node = $world_canvas/world_node
onready var selected_node = null

var signal_sfx = preload("res://sound/player/ui_sfx/ethereal_alert.wav")

var level_select_initiated = false

var make_ethereal_sound_interval = 1

var world_inst = []

var world_nodes = []
var world_status_array = []

var world_status_dict = {}

func _ready() -> void:
	cam.zoom = Vector2(0.001, 0.001)
	world_nodes = get_tree().get_nodes_in_group("wrld_node")
	m_right = $selection_box/rect.margin_right
	m_left = $selection_box/rect.margin_left
	m_down =  $selection_box/rect.margin_bottom
	m_up =  $selection_box/rect.margin_top

func save_node_states_to_disk():
	pass

func _draw() -> void:
	if Input.is_action_just_pressed("USE"):
		closest_node.unlocked = true
	
	if Input.is_action_just_pressed("ALT_CLICK"):
		pass
	
	if Input.is_action_just_pressed("CLICK"):
		pass
		
	if Input.is_action_just_pressed("JUMP"):
		for i in world_nodes:
			i.unlocked = false
	
	
	progress_inducing_node_array.clear()
	for i in range(world_nodes.size()):
		world_nodes[i].sin_vel = i * -80
		world_nodes[i].global_scale = cam.zoom
		world_nodes[i].cam_zoom = cam.zoom.length()
		if world_nodes[i].progress_inducing:
			progress_inducing_node = world_nodes[i]
			progress_inducing_node_array.append(world_nodes[i])
		 
	global.player_pos = cam.position	
func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("FULLSCREEN"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if event.is_action_pressed("SCROLL_UP"):
		if zoom > 1:
			fx.spwn_sound(preload("res://sound/player/general/dash.wav"), global.player_pos, 25, 0.4)
			zoom = 1
	if event.is_action_pressed("SCROLL_DOWN"):
		for i in world_nodes:
			i.selected = false
		selected_node = null
		if zoom < 1:
			zoom = 1
		else:
			zoom = 1.5
	
func _physics_process(delta: float) -> void:
	update()
	find_nearest_wrld_node(delta)
	selection_system(delta)
	camera_system(delta)
	find_last_selectable_node(delta)
	behavoiur_when_theres_selected_node(delta)
	
	if progress_inducing_node_array != []:
		make_ethereal_sound_interval -= delta
		if make_ethereal_sound_interval < 0:
			for i in progress_inducing_node_array:
				fx.spwn_circ(i.global_position, 64, 0, 0)
				fx.spwn_circ(i.global_position, 64, 0, 0.05)
				fx.spwn_circ(i.global_position, 64 , 0, 0.1)
				fx.spwn_circ(i.global_position, 64 , 0, 0.15)
			fx.spwn_sound(signal_sfx, global.player_pos, -15, 0.9)
			make_ethereal_sound_interval = 2
	
	global.shake /= 1.3
	$Camera2D.offset = Vector2(rand_range(-global.shake, global.shake), rand_range(-global.shake, global.shake))
	
	if selected_node == null and Input.is_action_just_pressed("CLICK") and closest_node.global_position.distance_squared_to(get_global_mouse_position()) < hover_dist and closest_node.unlocked:
		for i in world_nodes:
			i.selected = false
		selected_node = null
		
		
		fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -10, 0.3)
		fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -10, 10)
		fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -10, 5	)
		fx.spwn_sound(preload("res://sound/player/ui_sfx/click1.wav"))
		fx.spwn_sound(preload("res://sound/player/ui_sfx/click.wav"))
		
		closest_node.selected = true
		selected_node = closest_node
		
	if Input.is_action_just_pressed("ALT_CLICK"):
		for i in world_nodes:
			i.selected = false
		selected_node = null
	
#	if Input.is_action_just_pressed("ALT_CLICK"):
#		pan_pos = get_global_mouse_position()
#		cam_pan_pos = cam.position 
#
#	if Input.is_action_pressed("ALT_CLICK"):
#		scroll_x += (pan_pos.x - get_global_mouse_position().x) + cam_pan_pos.x
#		scroll_y += (pan_pos.y  - get_global_mouse_position().y) + cam_pan_pos.y

func behavoiur_when_theres_selected_node(delta):
	if selected_node != null:
		just_deselected_a_node = false
		if just_selected_a_node == false:
			zoom = 0.5
			just_selected_a_node = true
		
		if Input.is_action_just_pressed("CLICK") and not level_select_initiated:
			
			fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -5, 0.3)
			fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, -5, 2)
			fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), global.player_pos, 0, 1)
			fx.spwn_sound(preload("res://sound/SFX/poouum.wav"), global.player_pos, 4, 1)
			fx.spwn_sound(preload("res://sound/SFX/poouum.wav"), global.player_pos, 4, 0.7)
			fx.spwn_sound(preload("res://sound/SFX/poouum.wav"), global.player_pos, 4, 1.5)
			fx.spwn_sound(preload("res://sound/SFX/poouum.wav"), global.player_pos, 4, 0.5)
			fx.spwn_sound(preload("res://sound/SFX/seismic-slam.wav"), global.player_pos, -20, 1)
			
			
			level_select_initiated = true
			
		if level_select_initiated:
			$Camera2D/ui/select_node_ui.modulate = $Camera2D/ui/select_node_ui.modulate.linear_interpolate(Color.transparent, delta * 5)
			$Camera2D/ui/fade.modulate = $Camera2D/ui/fade.modulate.linear_interpolate(Color.white, delta * 5)
			cam.zoom -= Vector2(0.5,0.5) * delta
			
			if cam.zoom < Vector2(0.05, 0.05):
				game.scene_to_load = selected_node.level_to_load
				game.loadscene()
			
		else:
			$Camera2D/ui/fade.modulate = $Camera2D/ui/fade.modulate.linear_interpolate(Color.transparent, delta * 3)
		$Camera2D/ui/select_node_ui.modulate = $Camera2D/ui/select_node_ui.modulate.linear_interpolate(Color(1,1,1), delta * 5)
		$Camera2D/ui/select_node_ui/level_name.text = str(selected_node.node_name)
		$Camera2D/ui/select_node_ui/level_desc.text = str(selected_node.node_desc)
		$Camera2D/ui/select_node_ui/level_name.rect_position.x += (59 - $Camera2D/ui/select_node_ui/level_name.rect_position.x) * 0.1
		scroll_x = selected_node.global_position.x
		scroll_y = selected_node.global_position.y
			
		
		$Camera2D/ui/select_node_ui/level_name/line.scale.x = $Camera2D/ui/select_node_ui/level_name.text.length() * 10
		$Camera2D/ui/location_text.modulate = $Camera2D/ui/location_text.modulate.linear_interpolate(Color.transparent, delta * 3)
	else:
		$Camera2D/ui/fade.modulate = $Camera2D/ui/fade.modulate.linear_interpolate(Color.transparent, delta * 3)
		$Camera2D/ui/select_node_ui/level_name.rect_position.x += (159 - $Camera2D/ui/select_node_ui/level_name.rect_position.x) * 0.1
		level_select_initiated = false
		just_selected_a_node = false
		$Camera2D/ui/select_node_ui.modulate = $Camera2D/ui/select_node_ui.modulate.linear_interpolate(Color.transparent, delta * 5)
		if just_deselected_a_node == false:
			zoom = 1
			just_deselected_a_node = true
		$Camera2D/ui/location_text.modulate = $Camera2D/ui/location_text.modulate.linear_interpolate(Color.white, delta * 5)
		
func camera_system(delta):
	if Input.is_action_pressed("RIGHT"):
		scroll_x += zoom * 5
	if Input.is_action_pressed("LEFT"):
		scroll_x -= zoom * 5
	if Input.is_action_pressed("DOWN"):
		scroll_y += zoom * 5
	if Input.is_action_pressed("UP"):
		scroll_y -= zoom * 5
	
	if not level_select_initiated:
		cam.zoom += (Vector2(zoom, zoom) - cam.zoom) * 0.08
	
	if Input.is_action_just_pressed("ALT_CLICK"):
		pan_pos = get_global_mouse_position()
		cam_pan_pos = cam.position 

	if Input.is_action_pressed("ALT_CLICK"):
		var current_mouse_pos = get_global_mouse_position()
		var offset = (pan_pos - current_mouse_pos) * pan_strength * delta
		scroll_x += offset.x
		scroll_y += offset.y
		pan_pos = current_mouse_pos
		fx.spwn_sound(preload("res://sound/player/ui_sfx/click.wav"), global.player_pos, rand_range(-30, -10), rand_range(10, 30))
		
		
	cam.position += (Vector2(scroll_x, scroll_y) - cam.position) * 0.1

	if Input.is_action_just_pressed("ui_accept"):
		scroll_x = progress_inducing_node.global_position.x
		scroll_y = progress_inducing_node.global_position.y
		zoom = 1
	
#	cam.position += (get_global_mouse_position() / 15 - cam.position) * 0.1

func find_nearest_wrld_node(delta):
	closest_node_distance = INF
	
	var nodes = get_tree().get_nodes_in_group("wrld_node")
	for n in nodes:
		n.hovered = false
		var dist = n.global_position.distance_squared_to(get_global_mouse_position())
		if dist < closest_node_distance:
			closest_node_distance = dist
			if n.global_position.distance_squared_to(get_global_mouse_position()) < hover_dist:
				closest_node = n
			

func find_last_selectable_node(delta):
	pass

func selection_system(delta):
	if selected_node == null and closest_node.global_position.distance_squared_to(get_global_mouse_position()) < hover_dist and closest_node.unlocked:
		closest_node.hovered = true
		margin_scale += (1 - margin_scale) * 0.2
		selection_box.modulate = Color.white
		$selection_box/rect_unmasked/Label.percent_visible += 3 * delta
		
#		$selection_box/rect/Sprite.scale = Vector2(
#			float($selection_box/rect/Sprite.texture.get_width()),
#			float($selection_box/rect/Sprite.texture.get_height())
#		) / ($selection_box/rect/Sprite.texture.get_width() + $selection_box/rect/Sprite.texture.get_height()) / 2
		
	else:
		$selection_box/rect_unmasked/Label.percent_visible /= 1.1
		selection_box.modulate = selection_box.modulate.linear_interpolate(Color.transparent, delta * 15)
		margin_scale /= 1.3
		
	selection_box.scale = cam.zoom
	
	$selection_box/rect.margin_right += (m_right * margin_scale - $selection_box/rect.margin_right) * 0.16
	$selection_box/rect.margin_left += (m_left * margin_scale - $selection_box/rect.margin_left) *  0.12
	$selection_box/rect.margin_bottom += (m_down * margin_scale - $selection_box/rect.margin_bottom) * 0.08
	$selection_box/rect.margin_top += (m_up * margin_scale - $selection_box/rect.margin_top) * 0.4
	
	$selection_box/rect_unmasked.margin_right = $selection_box/rect.margin_right
	$selection_box/rect_unmasked.margin_left = $selection_box/rect.margin_left
	$selection_box/rect_unmasked.margin_bottom = $selection_box/rect.margin_bottom
	$selection_box/rect_unmasked.margin_top = $selection_box/rect.margin_top
	
	$selection_box/rect_unmasked/Label.text = str(closest_node.node_name)
	
	$selection_box/rect.self_modulate = Color.white
	
	if closest_node.global_position.x >= cam.position.x: 
		selection_box.position.x -= 8 * cam.zoom.length()
	else:
		selection_box.position.x += 8 * cam.zoom.length()
	
	selection_box.global_position = selection_box.global_position.linear_interpolate(closest_node.global_position, delta * 10)
	
	if selection_box.position.y + 40 < cam.position.y - 135:
		selection_box.position.y = cam.position.y - 135 + 40
	
#		closest_wpn_dist = INF
#		for ground_wpn in ground_weapons_array:
#			ground_wpn.is_near_player = false
#			var distance = ground_wpn.global_position.distance_squared_to(global_position)
#			if distance < closest_wpn_dist:
#				closest_wpn_dist = distance
#				closest_weapon = ground_wpn
