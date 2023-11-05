extends Node2D

var water_sections = []
var last_pos = Vector2.ZERO


func _ready() -> void:
	water_sections = get_tree().get_nodes_in_group("water_section")

func _physics_process(delta: float) -> void:
	global.submerged = false
	global.inside_water = false
	global.touch_water = false
	
	if not global.in_transition:
		for i in range(water_sections.size()):
#			water_sections[i].activated = false
			
			if global.camera_pos.x > water_sections[i].segpos_first_x - 250 and global.camera_pos.x < water_sections[i].segpos_last_x + 250:
				water_sections[i].near_player = true
				water_sections[i].show()
			else:
				water_sections[i].hide()
				water_sections[i].near_player = false
			
	#		if global.player_pos.x > water_sections[i].segpos_first_x and global.player_pos.x < water_sections[i].segpos_last_x and global.player_pos.y < water_sections[i].global_position.y and global.player_pos.y > water_sections[i].global_position.y - water_sections[i].get_node("underwater_rect").margin_bottom:
	#			water_sections[i].near_player = true
	#		else:
	#			water_sections[i].near_player = false
			
	#		if global.player_pos.distance_squared_to(water_sections[i].pos_for_near_player_detection) < 50000:
	#			water_sections[i].near_player = true
	#		else:
	#			water_sections[i].near_player = false
			
			if water_sections[i].player_touch_water:
				global.touch_water = true
			
			if water_sections[i].player_inside_water:
				global.inside_water = true
				
			if water_sections[i].player_submerged:
				global.submerged = true
	

	
