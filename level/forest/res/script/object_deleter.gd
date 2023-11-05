extends Area2D



func _on_object_deleter_body_entered(body: Node) -> void:
	body.queue_free()

func _on_object_deleter_area_entered(area: Area2D) -> void:
	area.queue_free()
