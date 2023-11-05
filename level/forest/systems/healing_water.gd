extends water

func _ready() -> void:
	surface_color = Color.cyan
	water_color = Color8(0, 255, 255, 100)

func _physics_process(delta: float) -> void:
	water_color = Color8(0, 255,255, 50)
	if player_touch_water:
		if global.health < global.max_health:
			global.health += 1
			var p = get_tree().get_nodes_in_group("p")
			p[0].get_node("sprite").modulate = Color8(0,2255,2255)
		
		$player_in_water.volume_db += (0 - $player_in_water.volume_db) * 0.1
		$player_in_water2.volume_db += (-10 - $player_in_water2.volume_db) * 0.1
		$player_in_water.global_position = global.player_pos
		$heal_fx.modulate = $heal_fx.modulate.linear_interpolate(Color.white, delta * 3)
		$heal_fx.self_modulate = $heal_fx.self_modulate.linear_interpolate(Color8(0, 255, 255, 200), delta * 3)
		$heal_fx/heal_particles.emitting = true
	else:
		$heal_fx/heal_particles.emitting = false
		$heal_fx.self_modulate = $heal_fx.self_modulate.linear_interpolate(Color.transparent, delta * 3)
		$heal_fx.modulate = $heal_fx.modulate.linear_interpolate(Color.transparent, delta * 3)
		$player_in_water.volume_db += (-999 - $player_in_water.volume_db) * 0.01
		$player_in_water2.volume_db += (-999 - $player_in_water2.volume_db) * 0.01
	$heal_fx.global_position = global.player_pos
	
	if $idle.global_position.distance_squared_to(global.player_pos) < 31000:
		fx.cam_get_to_pos = $idle.global_position + Vector2(0, -32)
