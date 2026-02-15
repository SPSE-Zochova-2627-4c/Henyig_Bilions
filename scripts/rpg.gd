extends Control
const projectile = preload("uid://cu2gewcpqmm25")
const J = preload("uid://uuo0ujb2u4yh")
@onready var player: CharacterBody3D = $"../../.."
@onready var ray_cast_3d: RayCast3D = $"../../Marker3D/RayCast3D"
@onready var marker_3d: Marker3D = $"../../Marker3D"
@onready var text_edit: TextEdit = $TextEdit
@onready var gun: AnimatedSprite2D = $gun


@export var shoot_time: float = 0.75
@export var max_clip: int = 4
var time = 0
var start = false
var shoot = false
var cur_shoot_time = 0



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text_edit.text = str(player.rpg_clip,"/",player.rpg_ammo)
	
	if Input.is_action_pressed("left_click") and not shoot:
		if player.rpg_clip > 0:
			start = false
			cur_shoot_time = 0
			shoot = true
			player.rpg_clip -= 1
			shoot_projectile()
			gun.play("shoot")





	if shoot:
		cur_shoot_time += delta
		if cur_shoot_time > shoot_time:
			shoot = false
			gun.play("idle")

	if start:
		time += delta
		if time > 1:
			if player.rpg_ammo+player.rpg_clip >= max_clip:
				player.rpg_ammo += player.rpg_clip
				player.rpg_ammo -= max_clip
				player.rpg_clip = max_clip
			else:
				player.rpg_clip = player.rpg_ammo
				player.rpg_ammo = 0
			gun.play("idle")
			start = false


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
	
func _input(event):
	if event.is_action_pressed("reload") and player.rpg_ammo > 0 and player.rpg_clip < max_clip and not shoot:
		start = true
		time = 0
		gun.play("reload")
