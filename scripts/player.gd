extends CharacterBody3D

@export var hitscn_dmg: int = 40
@export var projectile:PackedScene
@onready var camera_3d: Camera3D = $Camera3D
@onready var marker_3d: Marker3D = $Camera3D/Marker3D
@export var explosion_dramaticism: float = 0.15

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var ray_range = 2000
var mouse_sensitivity = 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp = 500

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	if event.is_action_pressed("right_click"):
		shoot_projectile()	
		
	if event.is_action_pressed("left_click"):
		hitscan()




func shoot_projectile():
	var p = projectile.instantiate()
	p.position = marker_3d.global_position
	p.rotation = marker_3d.global_rotation
	add_sibling(p)
	


func hitscan():
	var centre = camera_3d.get_viewport().get_size() / 2
	var ray_origin = camera_3d.project_ray_origin(centre)
	var ray_end = ray_origin + camera_3d.project_ray_normal(centre) * ray_range

	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(query)

	if !intersection.is_empty():
		if intersection.collider.has_method("damage"):
			intersection.collider.damage(hitscn_dmg)
	
	
	
func get_explode(dmg,from_pos):
	hp -= dmg

	var direction = self.global_position.direction_to(from_pos)
	var speed = explosion_dramaticism * dmg
	direction *= -speed
	
	velocity += direction
