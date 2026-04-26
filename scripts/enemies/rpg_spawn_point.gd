extends Node3D
@onready var player = get_tree().get_root().get_node("World").get_node("Player").get_node("shit")
const projectile = preload("uid://cu2gewcpqmm25")
@onready var guy: CharacterBody3D = $".."


func spawn_rocket():
	look_at(Vector3(player.global_position.x,player.global_position.y,player.global_position.z))
	var p = projectile.instantiate()
	p.position = global_position
	p.rotation = global_rotation
	guy.add_sibling(p)
