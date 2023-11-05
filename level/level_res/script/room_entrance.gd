extends Node2D

export var scene_index_to_change = 2

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("USE") and position.distance_squared_to(global.player_pos) < 600:
		global.change_level_to = scene_index_to_change

