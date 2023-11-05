extends KinematicBody2D

var menuopen = false
onready var core = $Viewport/core
onready var animation_player = $Viewport/AnimationPlayer

onready var main = $core_ui/main

enum menu_section {
	MAIN,
	UPGRADE,
}

var current_section = menu_section.MAIN

func _ready() -> void:
	$core_ui/bg.show()

func _physics_process(delta: float) -> void:
	if position.distance_squared_to(global.camera_pos) < 69500:
		core.show()
		animation_player.playback_active = true
		$Viewport/core.visible = true
		$selection_3d/Spatial.visible = true
	else:
		core.hide()
		animation_player.playback_active = false

	input_use_handling(delta)
	$Sprite.position.y = sin(OS.get_ticks_msec() * delta * 0.25) * 10

func input_use_handling(delta):
	if menuopen:
		$core_ui.show()
		$core_ui/bg.rect_position.y /= 1.4
	else:
		$core_ui.hide()
		$core_ui/bg.rect_position.y = -500
		
	if position.distance_squared_to(global.player_pos) < 2200:
		$Sprite.scale = $Sprite.scale.linear_interpolate(Vector2(0.7, 0.7), delta * 5)
		if Input.is_action_just_pressed("USE"):
			menuopen = !menuopen
			
			if menuopen:
				fx.spwn_sound(preload("res://sound/player/ui_sfx/btn.wav"), position, 0, 0.3)
				var p = get_tree().get_nodes_in_group("p")
				global.player_pause = true
				get_tree().paused = true
			else:
				get_tree().paused = false
				var p = get_tree().get_nodes_in_group("p")
				global.player_pause = false
	else:
		$Sprite.scale = $Sprite.scale.linear_interpolate(Vector2(0.5,0.5), delta * 5)
		if Input.is_action_just_pressed("USE"):
			menuopen = false
	
	manage_menus(delta)

func manage_menus(delta):
	if menuopen:
		var p = get_tree().get_nodes_in_group("cam")
		p[0].z = 0.5
		if current_section == menu_section.MAIN:
			main.active = true
		else:
			main.active = false
	else:
		main.active = false
		
	
	
