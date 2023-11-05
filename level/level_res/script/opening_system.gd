extends Node2D

var opening_scene_duration = 5
var opening_just_ended = false
var opening_just_ended_1 = false


var mode_announce_screen = preload("res://player/main/ui/game_mode_announce_screen/game_mode_announce_ui.tscn")

func _input(event: InputEvent) -> void:
	if event.is_pressed() and opening_scene_duration >= 0:
		opening_scene_duration = 0
		

func _physics_process(delta: float) -> void:
	opening_scene_duration -= delta
	if opening_scene_duration > 0:
		
		var p = get_tree().get_nodes_in_group("p")
		p[0].hideui()
		global.player_pause = true
		opening_just_ended = false
		
#		fx.cam_get_to_pos = global.player_pos + (Vector2(-10,-10) * opening_scene_duration) * 10
		var cam = get_tree().get_nodes_in_group("cam")[0]
		fx.cam_get_to_pos = global.player_pos + Vector2(-10,-10) * opening_scene_duration * 10
		
		
	elif opening_scene_duration < -0.5:
		if opening_just_ended == false:
			
			var p = get_tree().get_nodes_in_group("p")
			p[0].showui()
			global.player_pause = false
			opening_just_ended = true
			
		if opening_scene_duration < -5:
			if opening_just_ended_1 == false:
				var mode_announce_screen_inst = mode_announce_screen.instance()
				get_parent().add_child(mode_announce_screen_inst)
				opening_just_ended_1 = true
		
		
func _ready() -> void:
	var game_mode = get_tree().get_nodes_in_group("game_mode")[0]
	$opening_title/Label.text = str(game_mode.level_name)

