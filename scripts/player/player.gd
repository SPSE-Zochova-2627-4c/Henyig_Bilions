extends CharacterBody3D

const pistol = preload("uid://dureo6lwixg0")
const hand = preload("uid://c31fi4iayokx6")
const RPG = preload("uid://jcobrh6oadkh")
const KNIFE = preload("uid://dfvk5kghbnrnb")

@onready var canvas_layer: CanvasLayer = $Camera3D/CanvasLayer
@export var hitscn_dmg: int = 40

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var camera_3d: Camera3D = $Camera3D
@onready var marker_3d: Marker3D = $Camera3D/Marker3D
@export var explosion_dramaticism: float = 0.1
@onready var ray_cast_3d: RayCast3D = $Camera3D/Marker3D/RayCast3D

var SPEED = 6.5
const JUMP_VELOCITY = 3.5
@export var JUMP_SPEED = 6.5
var ray_range = 2000
var mouse_sensitivity = 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp = 500
var on_floor = true




var in_hand = hand.instantiate()
var in_hand_scene = hand
var prev_hand_scene = hand
@export var pistol_ammo = 48
@export var rpg_ammo = 24
var pistol_clip: int = 0
var rpg_clip: int = 0
var bhop = 0
@export var bhop_time = 0.2

func _ready():
	add_child(in_hand)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if on_floor != is_on_floor():
		if not on_floor:
			bhop = 0.1
		on_floor = is_on_floor()
		
		
		
	if bhop > 0:
		bhop -= delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		if bhop > 0:
			audio_stream_player.play()
			velocity.y = JUMP_VELOCITY*1.5
		else:
			velocity.y = JUMP_VELOCITY




	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and is_on_floor():
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.z = move_toward(velocity.z, 0, 0.5)
	elif direction:
		velocity.x = move_toward(velocity.x, direction.x*JUMP_SPEED, delta*20)
		velocity.z = move_toward(velocity.z, direction.z*JUMP_SPEED, delta*20)
	move_and_slide()





func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))


	if event.is_action_pressed("quick_switch"):
		in_hand.queue_free()
		in_hand = prev_hand_scene.instantiate()
		var values = [prev_hand_scene, in_hand_scene]
		swap(values)
		prev_hand_scene = values[0]
		in_hand_scene = values[1]
		self.canvas_layer.add_child(in_hand)

	if event.is_action_pressed("1"):
		prev_hand_scene = in_hand_scene
		in_hand_scene = KNIFE
		in_hand.queue_free()
		in_hand = KNIFE.instantiate()
		self.canvas_layer.add_child(in_hand)
		
	if event.is_action_pressed("2"):
		prev_hand_scene = in_hand_scene
		in_hand_scene = pistol
		in_hand.queue_free()
		in_hand = pistol.instantiate()
		self.canvas_layer.add_child(in_hand)
		
	if event.is_action_pressed("3"):
		prev_hand_scene = in_hand_scene
		in_hand_scene = RPG
		in_hand.queue_free()
		in_hand = RPG.instantiate()
		self.canvas_layer.add_child(in_hand)





func damage(dmg,push_force,from_pos,_blood_point):
	hp -= dmg
	var direction = self.global_position.direction_to(from_pos)
	var speed = explosion_dramaticism * push_force
	direction *= -speed
	
	velocity += direction
	
func swap(arr):
	var j = arr[0]
	arr[0] = arr[1]
	arr[1] = j
