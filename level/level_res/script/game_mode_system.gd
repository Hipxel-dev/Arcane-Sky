extends Node2D

export var level_name = "insert_level_name_here"

enum gamemodes {
	EXTERMINATE,    # 0
	SURVIVAL,       # 1
	DEFENSE,        # 2
	CRYSTAL_DEFENSE # 3
}

export var current_gamemode = gamemodes.EXTERMINATE

export var exterminate_enemies_needed_to_kill = 80

export var survival_waves_needed_to_win = 5
export var survival_wave_duration = 60
export var survival_wave_break_duration = 15

export var defense_starting_crystal_health = 1000000
export var defense_time_needed_to_win = 5 # minutes


var enemy_spwn_counter = 7
export var enemy_spawn_interval_min_rand = 0.3
export var enemy_spawn_interval_max_rand = 2

export var enemies = [
	preload("res://enemy/enemies/enemy_membrane.tscn"),
	preload("res://enemy/enemies/enemy_eye_scepter.tscn"),
	preload("res://enemy/enemies/enemy_belch.tscn")
]

var last_enemy_count = 0

func _physics_process(delta: float) -> void:
	if current_gamemode == gamemodes.EXTERMINATE:
		
		# exterminate means no wave defense. so remove the upgrade station.
		if get_tree().get_nodes_in_group("core").size() != 0:
			var core = get_tree().get_nodes_in_group("core")
			core[0].queue_free()
		
		enemy_spwn_counter -= delta 
		if enemy_spwn_counter < 0 and exterminate_enemies_needed_to_kill >= 0:
			exterminate_enemies_needed_to_kill -= 1
			var enemy_inst = enemies[floor(rand_range(0, enemies.size() - 0.00001))].instance()
			enemy_inst.position = Vector2(rand_range(-global.camera_limit_x.x,global.camera_limit_x.y), rand_range(-0, -200))
			get_parent().add_child(enemy_inst)
			enemy_spwn_counter = rand_range(enemy_spawn_interval_min_rand, enemy_spawn_interval_max_rand)
			
			
		


