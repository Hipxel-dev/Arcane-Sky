extends Node2D

#
#var blue_flower = preload("res://effects/level_fx/blue_flower.tscn")
#onready var tilemap = $blue_flower_tile
#
#func _ready() -> void:
#	randomize()
#
#	for cellpos in tilemap.get_used_cells():
#		var cell = tilemap.get_cellv(cellpos)
#
#		for i in rand_range(1, 1):
#			var blue_flower_inst = blue_flower.instance()
#			blue_flower_inst.position = tilemap.map_to_world(cellpos) * tilemap.scale
#
#			blue_flower_inst.get_node("sfx").volume_db = rand_range(-5, 2)
#			blue_flower_inst.get_node("sfx").pitch_scale = rand_range(0.8, 5.5)
#			blue_flower_inst.rotation_degrees = 90
#
#			if rand_range(0, 1) > 0.5:
#				blue_flower_inst.z_index = -1
#
##			grass_inst.position += Vector2(rand_range(-5, 5), rand_range(-1, 5))
#			blue_flower_inst.position.y += 32
#
#			add_child(blue_flower_inst)
#		tilemap.set_cellv(cellpos, -1)
