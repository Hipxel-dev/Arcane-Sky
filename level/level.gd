extends Node2D

var level = 1
var playtime = 0

var level_color = Color8(127,127, 255, 255)

# Level list. i might have to reformat it into cell-like positional types tho. like level 0,0
var levels = [
	preload("res://level/forest/level (-1, 0).tscn"),
	preload("res://level/forest/level (0, 0).tscn"),
	preload("res://level/forest/level (1, 0).tscn"),
	preload("res://level/forest/level (-1, -1).tscn"),
	preload("res://level/debug.tscn")]

var current_level
var fade_scale = 0

var crate_spwn_rate = 1
var crate = preload("res://level/forest/res/prop_box.tscn")
var crates = []

func _ready() -> void:
	global.kalphite = 400
	fx
	global
	game

	$fadelayer/faderect.modulate = Color8(99999,99999,99999, 999)
	var level_inst = levels[level].instance()
	current_level = level_inst
	global.check_point_pos = level_inst.get_node("spwn_pos").global_position
	global.change_player_pos = level_inst.get_node("spwn_pos").global_position
	add_child(level_inst)

func _physics_process(delta: float) -> void:
	get_tree().get_root().size_override_stretch = true
	get_tree().get_root().own_world = true
	
	crates = get_tree().get_nodes_in_group("crate")
	
	if crates.size() < 23:
		crate_spwn_rate -= delta
	if crate_spwn_rate < 0:
		var crate_inst = crate.instance()
		var spwn = Vector2(rand_range(global.camera_limit_x.x + 64, global.camera_limit_x.y - 64), -90)
		crate_inst.position = spwn
		crate_inst.modulate = Color8(127,127, 255)
		crate_inst.add_to_group("crate")
		add_child(crate_inst)
#		fx.cam_get_to_pos = spwn
		crate_spwn_rate = rand_range(-0.1, 6)
	
	
	$fadelayer/faderect.modulate = $fadelayer/faderect.modulate.linear_interpolate(Color.transparent, delta * 4)
	playtime += delta
	
	
	if Input.is_action_just_pressed("ui_up"):
#		game.spwn_bullet_ammo(get_global_mouse_position())
#		game.spwn_shell_ammo(get_global_mouse_position())
		for i in range(100):
			game.spwn_kalphite(get_global_mouse_position())

	if Input.is_action_just_pressed("FULLSCREEN"):
		OS.window_fullscreen = !OS.window_fullscreen
		
	if global.change_level_to != -1 and playtime > 0.3:

		load_level(global.change_level_to)
		
		global.change_level_to = -1
		
	if global.health <= 0:
		var enm = get_tree().get_nodes_in_group("enemy")
		var p = get_tree().get_nodes_in_group("p")
		global.health = global.max_health
		p[0].position = global.check_point_pos
		for i in enm:
			i.queue_free()
			
#	var p = get_tree().get_nodes_in_group("p")
#	p[0].position.x = clamp(p[0].position.x, global.camera_limit_x.x + 12, global.camera_limit_x.y - 12)
#	p[0].position.y = clamp(p[0].position.y, global.camera_limit_y.x + 12, global.camera_limit_y.y - 12)
	
func load_level(lvl = null):
#	var player_weapons = get_tree().get_nodes_in_group("picked_up_weapon")
#	var weapons = []
	
#	for i in range(player_weapons.size()):
#		weapons.append(player_weapons[i].duplicate())
		
		
	if current_level != null:
		current_level.free()
	
	var p = get_tree().get_nodes_in_group("p")
	
#	p[0].movement = Vector2.ZERO
#	p[0].dash_vel = Vector2.ZERO
	
	global.reset_player_stuff = true
	
	var level_inst = levels[lvl].instance()
	current_level = level_inst
	global.check_point_pos = level_inst.get_node("spwn_pos").global_position
#	global.change_player_pos = level_inst.get_node("spwn_pos").global_position
	add_child(level_inst)
	
#	get_tree().paused = false
	
#	for i in range(weapons.size() - 1):
#		weapons[i].index = (i)
#		add_child(weapons[i])
