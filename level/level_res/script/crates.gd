extends Node2D

var crate = preload("res://level/forest/res/prop_box.tscn")
var spwn_intrvl = 1

func _physics_process(delta: float) -> void:
	spwn_intrvl -= delta
	
	var res_props = get_tree().get_nodes_in_group("res_prop")
	
	if spwn_intrvl < 0 and res_props.size() < 25:
		var crate_inst = crate.instance()
		crate_inst.position.x = rand_range(global.camera_limit_x.x + 100, global.camera_limit_x.y + 100)
		crate_inst.position.y = global.camera_limit_y.x
		crate_inst.modulate = get_parent().get_node("level").level_color
		crate_inst.add_to_group("res_prop")
		get_parent().add_child(crate_inst)
		
		spwn_intrvl = rand_range(2, 5)
		
