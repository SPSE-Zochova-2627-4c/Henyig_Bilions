extends CharacterBody3D


@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@export var hp: int = 200
@export var explosion_dramaticism: float = 2
@export var SPEED = 2.5
@export var JUMP_SPEED = 2.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const BLOOD_STREAM = preload("uid://c80pdwpxa1lr7")
var bleed_threshold = {140:true,120:true,80:true,40:true}
var move = true

@onready var external_force = false
@onready var target = get_tree().get_root().get_node("World").get_node("Player")

@onready var blood_points = {
	$blood_point:true,
	$blood_point2:true,
	$blood_point3:true,
	$blood_point4:true
}


@onready var tt = 0
@onready var time_after_stopping = 0

func clear_to_fire():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(self.global_position,target.global_position)
	var result = space_state.intersect_ray(query)
 
	if not result.is_empty() and result.collider == target:
		return true
	return false

func _physics_process(delta):
	tt += delta
	time_after_stopping += delta
	if tt >= 5 and not move and clear_to_fire() and time_after_stopping > 3:
		$RPGSpawnPoint.spawn_rocket()
		tt = 0
	look_at(Vector3(target.global_position.x,self.global_position.y,target.global_position.z))
	
	if hp <= 0:
		queue_free()
		
	if external_force:
		velocity.x = move_toward(velocity.x, 0, 0.1)
		velocity.z = move_toward(velocity.z, 0, 0.1)
		if velocity == Vector3.ZERO:
			external_force = false
	else:
		var destination = navigation_agent.get_next_path_position()
		var direction_to_destination = destination - global_position
		var direction = direction_to_destination.normalized()
		var nav_velocity = direction * SPEED
		navigation_agent.velocity = nav_velocity
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	#if direction and is_on_floor():
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#elif is_on_floor():
		#velocity.x = move_toward(velocity.x, 0, 0.5)
		#velocity.z = move_toward(velocity.z, 0, 0.5)
		
	move_and_slide()

	
	
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
	var speed = push_force/10
	direction *= -speed
	velocity += direction
	external_force = true

func setpath():
	if move:
		if self.global_position.distance_to(target.global_position) > 15:
			navigation_agent.target_position = target.global_position
		elif clear_to_fire():
			move = false
			time_after_stopping = 0
			navigation_agent.target_position = self.global_position
		else:
			navigation_agent.target_position = target.global_position
	elif not move and self.global_position.distance_to(target.global_position) > 30 or not clear_to_fire():
		move = true
		navigation_agent.target_position = target.global_position


func _on_timer_timeout() -> void:
	setpath()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if not external_force:
		velocity.x = safe_velocity.x
		velocity.z = safe_velocity.z
