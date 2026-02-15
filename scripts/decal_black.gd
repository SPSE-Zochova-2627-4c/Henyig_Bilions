extends Node3D
@onready var decal_black: Node3D = $"."

func _on_timer_timeout() -> void:
	decal_black.queue_free()
