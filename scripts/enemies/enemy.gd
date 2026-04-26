extends RigidBody3D
#@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
#@onready var capsule_rad = collision_shape_3d.shape.radius + 0.2
#@onready var capsule_height = (collision_shape_3d.shape.height + 0.1) * -1
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@export var hp: int = 200
@export var speed = 20
@export var explosion_dramaticism: float = 2
const BLOOD_STREAM = preload("uid://c80pdwpxa1lr7")
var bleed_threshold = {140:true,120:true,80:true,40:true}
@onready var target = get_tree().get_root().get_node("World").get_node("player")
@onready var blood_points = {
	$blood_point:true,
	$blood_point2:true,
	$blood_point3:true,
	$blood_point4:true
}

func _process(_delta):
	if hp <= 0:
		queue_free()
	var dir = to_local(navigation_agent.get_next_path_position()).normalized()
	#velocity = dir * speed 

	
	
func spawn_blood(pos: Vector3):
	var p = BLOOD_STREAM.instantiate()
	add_child(p)
	p.global_position = pos
	p.rotate(Vector3(0,1,0), randf_range(0, 2*PI))

func damage(dmg,push_force,from_pos,blood_point):
	hp -= dmg
	for threshold in bleed_threshold:
		if bleed_threshold[threshold] and hp <= threshold:
			bleed_threshold[threshold] = false
			if blood_point is bool:
				var dist = -1
				for bp in blood_points:
					if blood_points[bp]:
						if dist == -1:
							dist = from_pos.distance_to(bp.global_position)
							blood_point = bp
							
						elif from_pos.distance_to(bp.global_position) < dist:
							dist = from_pos.distance_to(bp.global_position)
							blood_point = bp
				blood_points[blood_point] = false
				blood_point = blood_point.global_position
					
				#var ratio = randf_range(0, capsule_rad)
				##var ray_spawn_point = Vector3(self.global_position.x+(randi_range(-1,0)*ratio)*5,self.global_position.y-randf_range(0, capsule_height),self.global_position.z+(randi_range(-1,0)*(capsule_rad-ratio))*5)
				#var ray_spawn_point = Vector3(self.global_position.x+50,self.global_position.y,self.global_position.z+50)
				#var space_state = get_world_3d().direct_space_state
				#var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_spawn_point, self.global_position,self.collision_mask))
				#if intersection["collider_id"] == self.get_instance_id():
					#pass
				#blood_point = intersection["position"]
			spawn_blood(blood_point)
			blood_point = false
	var direction = self.global_position.direction_to(from_pos)
	var speed = explosion_dramaticism * push_force
	direction *= -speed
	self.apply_central_impulse(direction)

func setpath():
	navigation_agent.target_position = target.global_position

func _on_timer_timeout() -> void:
	setpath()
