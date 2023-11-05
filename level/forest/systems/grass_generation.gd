extends Node2D

var textures = [
	preload("res://art/level_art/grass1.png"),
	preload("res://art/level_art/grass2.png"),
	preload("res://art/level_art/grass.png")]

var grass = preload("res://effects/level_fx/grass.tscn")
onready var tilemap = $grass_tile

func _ready() -> void:
	randomize()
	
	for cellpos in tilemap.get_used_cells():
		var cell = tilemap.get_cellv(cellpos)

		for i in rand_range(1, 1):
			var grass_inst = grass.instance()
			grass_inst.position = tilemap.map_to_world(cellpos) * tilemap.scale
			grass_inst.scale.x = rand_range(0.5, 2)


			grass_inst.texture = textures[round(rand_range(0, 2.49))]
			grass_inst.rotation_degrees = 90

			if rand_range(0, 1) > 0.5:
				grass_inst.z_index = -1

			grass_inst.position += Vector2(rand_range(-5, 5), rand_range(-1, 5))
			grass_inst.position.y += 15
#
#			add_child(grass_inst)
		tilemap.set_cellv(cellpos, -1)
		

