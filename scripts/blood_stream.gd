extends Node3D
@onready var area_3d: Area3D = $Area3D
var tm = 0
const J = preload("uid://uuo0ujb2u4yh")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tm += delta
	if tm >= 0.5:
		tm = 0
		if area_3d.get_overlapping_bodies():
			var rid := area_3d.get_rid()
			var state := PhysicsServer3D.body_get_direct_state(rid)
			spawn(state.get_contact_collider_position(1),Vector3.ZERO)




func spawn(pos: Vector3, normal: Vector3):
	var p = J.instantiate()
	area_3d.add_sibling(p)
	p.position = pos
	if normal != Vector3.UP:
		# look in the direction of the normal1
		p.look_at(pos + normal, Vector3.UP)
		# then look "up" from there so the decal projects "down"
		p.transform = p.transform.rotated_local(Vector3.RIGHT, PI/2.0)
	p.rotate(normal, randf_range(0, 2*PI))
