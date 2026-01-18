extends RigidBody3D


const DECAL_BLACK = preload("uid://cmj0ryqpeodd4")
@export var speed: float = 2.0
@onready var expl_area: Area3D = $ExplArea
@onready var collision_shape_3d: CollisionShape3D = $ExplArea/CollisionShape3D
@export var max_expl_dmg: float = 100

var repeat = false
var exploding = false
var applied = []
var remaining_time := 0.2     
var expansion_speed := 30.0  
var dmg_falloff_speed := 300.0



func _process(delta: float) -> void:
	move_and_collide(-transform.basis.z * delta * speed)
	
	if not exploding:
		return
	#print(max_expl_dmg)
	var expand = expansion_speed * delta
	collision_shape_3d.scale += Vector3.ONE * expand
	collision_shape_3d.force_update_transform()
	
	for body in expl_area.get_overlapping_bodies():
		if body.has_method("get_explode") and body not in applied:
			applied.append(body)
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(self.global_position, body.global_position)
			var result = space_state.intersect_ray(query)
			if result.collider == body:
				body.get_explode(int(round(max_expl_dmg)),self.global_position)
				
	max_expl_dmg -= dmg_falloff_speed * delta
	remaining_time -= delta
	if remaining_time <= 0:
		queue_free()
	



	
#func explode():
	#var applied = []
	#for iteration in range(30):
		#print(max_expl_dmg)
		#collision_shape_3d.scale += Vector3(0.17,0.17,0.17)
		#collision_shape_3d.force_update_transform()
		#await get_tree().process_frame
		#for body in expl_area.get_overlapping_bodies():
			#if body not in applied:
				#applied.append(body)
				#if body.has_method("get_explode"):
					#max_expl_dmg = int(round(max_expl_dmg))
					#body.get_explode(max_expl_dmg)
					#
		#max_expl_dmg -= 2.5
	#queue_free()
	

	





func _on_area_3d_body_entered(_body: Node3D) -> void:
	if repeat == false:
		visible = false
		exploding = true
		repeat = true
		
		var p = DECAL_BLACK.instantiate()
		p.position = global_position

		
		p.rotation.y = global_rotation.y
		print(global_rotation,p.rotation)
		add_sibling(p)
	
