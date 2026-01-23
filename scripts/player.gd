extends CharacterBody3D

const J = preload("uid://uuo0ujb2u4yh")

@export var hitscn_dmg: int = 40
@export var projectile:PackedScene
@onready var camera_3d: Camera3D = $Camera3D
@onready var marker_3d: Marker3D = $Camera3D/Marker3D
@export var explosion_dramaticism: float = 0.1
@onready var ray_cast_3d: RayCast3D = $Camera3D/Marker3D/RayCast3D

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
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))
	
	if event.is_action_pressed("right_click"):
		shoot_projectile()	
		
	if event.is_action_pressed("left_click"):
		hitscan()




func shoot_projectile():
	var p = projectile.instantiate()
	p.position = marker_3d.global_position
	p.rotation = marker_3d.global_rotation
	add_sibling(p)
	
	
func spawn(pos: Vector3, normal: Vector3):
	var p = J.instantiate()
	var col = ray_cast_3d.get_collider()
	col.add_sibling(p)
	p.position = pos
	if normal != Vector3.UP:
		# look in the direction of the normal
		p.look_at(pos + normal, Vector3.UP)
		# then look "up" from there so the decal projects "down"
		p.transform = p.transform.rotated_local(Vector3.RIGHT, PI/2.0)
	p.rotate(normal, randf_range(0, 2*PI))

func hitscan():
	if ray_cast_3d.is_colliding():
		spawn(ray_cast_3d.get_collision_point(), ray_cast_3d.get_collision_normal())
		
		if ray_cast_3d.get_collider().has_method("damage"):
			ray_cast_3d.get_collider().damage(hitscn_dmg)



func get_explode(dmg,from_pos):
	hp -= dmg

	var direction = self.global_position.direction_to(from_pos)
	var speed = explosion_dramaticism * dmg
	direction *= -speed
	
	velocity += direction
