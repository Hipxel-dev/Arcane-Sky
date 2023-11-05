extends NinePatchRect

export var left_lvl = -1
export var  right_lvl = -1
export var  up_lvl = -1
export var  down_lvl = -1

var chk_delay = 0.3

func _ready() -> void:
	global.camera_limit_x.x = margin_left 
	global.camera_limit_x.y = margin_right  
	
	global.camera_limit_y.x = margin_top 
	global.camera_limit_y.y = margin_bottom
	hide()
	
func _physics_process(delta: float) -> void:
	chk_delay -= delta
	
	global.camera_limit_x.x = margin_left 
	global.camera_limit_x.y = margin_right  
	
	global.camera_limit_y.x = margin_top 
	global.camera_limit_y.y = margin_bottom
	
	if chk_delay <= 0:

		if global.player_pos.x > global.camera_limit_x.y and right_lvl != -1: # to right side
			global.change_level_to = right_lvl
		if global.player_pos.x < global.camera_limit_x.x and left_lvl != -1: # to left side
			global.change_level_to = left_lvl
		if global.player_pos.y < global.camera_limit_y.x and up_lvl != -1: # to up side
			global.change_level_to = up_lvl
		if global.player_pos.y > global.camera_limit_y.y and down_lvl != -1: # to down side
			global.change_level_to = down_lvl
