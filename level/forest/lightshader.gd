extends Sprite

var circ = preload("res://art/effects_art/general/bigcirc.png")
var circ_arr_pos = []

func _draw() -> void:
	for i in range(circ_arr_pos.size()):
		draw_texture(circ, circ_arr_pos[i])
		

func _physics_process(delta: float) -> void:
	update()
	
	if Input.is_action_just_pressed("CLICK"):
		add_circ(get_global_mouse_position())
		
func add_circ(pos):
	circ_arr_pos.append(pos)
