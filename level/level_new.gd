extends Node2D

onready var level_in_scene = null
var level_to_load = preload("res://level/debug.tscn")

var level_color = Color8(150,150, 255)
var spwn_pos = Vector2.ZERO

func _ready() -> void:
	global
	game
	fx
	
	global.ability_point += 5
	global.gem = 2000
	global.kalphite = 2000

var init = false

func _physics_process(delta: float) -> void:
	# ::fade out fx::
	$fadelayer/faderect.modulate = $fadelayer/faderect.modulate.linear_interpolate(Color.transparent, delta * 1)
	
	# ::player border limiting::
	var p = get_tree().get_nodes_in_group("p")[0]
	p.position.x = clamp(p.position.x, global.camera_limit_x.x - 32, global.camera_limit_x.y + 32)
	
	# ::level loading sytem::
	if level_to_load != null:
		if level_in_scene != null:
			level_in_scene.free()
	
		var level_inst = level_to_load.instance()
		level_in_scene = level_to_load
		global.check_point_pos = level_inst.get_node("spwn_pos").global_position
		p.position = global.check_point_pos
		add_child(level_inst)
	
		level_to_load = null

