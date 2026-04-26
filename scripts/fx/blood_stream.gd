extends Node3D

@onready var casts = [
	$RayCast3D,
	$RayCast3D2,
	$RayCast3D3
]




const J = preload("uid://cmj0ryqpeodd4")

@onready var pool_plant_location = self.get_global_transform_interpolated()
var tm = 0






func _process(delta: float) -> void:
	self.global_rotation.x = 0
	self.global_rotation.z = 0
	tm += delta
	if tm >= 0.5:
		tm = 0
		for ray in casts:
			if ray.is_colliding() and not_in_radius(pool_plant_location,self.get_global_transform_interpolated(),0.4):
				spawn(ray.get_collision_point(), ray.get_collision_normal(),ray)
				break


func not_in_radius(old, new, radius):
	var dx = new.origin.x - old.origin.x
	var dy = new.origin.y - old.origin.y
	var dz = new.origin.z - old.origin.z
	var rx = new.basis.x - old.basis.x
	
	if (dx*dx + dy*dy + dz*dz) > radius * radius:
		pool_plant_location = self.get_global_transform_interpolated()
		return true
	elif rx[0]>-0.8 and rx[0]<0.8 and rx[2]>-0.8 and rx[2]<0.8:
		return false
	else:
		pool_plant_location = self.get_global_transform_interpolated()
		return true


func spawn(pos: Vector3, normal: Vector3,r):
	var p = J.instantiate()
	var col = r.get_collider()
	col.add_sibling(p)
	p.global_position = pos
	if normal != Vector3.UP:
		# look in the direction of the normal1
		p.look_at((pos + normal), Vector3.UP)
		# then look "up" from there so the decal projects "down"
		p.transform = p.transform.rotated_local(Vector3.RIGHT, PI/2.0)
	p.rotate(normal, randf_range(0, 2*PI))
