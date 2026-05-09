extends Sprite3D
@onready var target = get_tree().get_root().get_node("World").get_node("Player")
@onready var inv = get_tree().get_root().get_node("World").get_node("Player").get_node("Camera3D").get_node("CanvasLayer").get_node("InvControl")
@export var pickup: InventoryItem




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == target:
		inv.add_item(pickup,1)
		queue_free()
