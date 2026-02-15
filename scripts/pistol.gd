extends Control

const J = preload("uid://uuo0ujb2u4yh")
const max_clip: int = 8


@export var hitscn_dmg: int = 40
@export var shoot_time: float = 0.25

@onready var player: CharacterBody3D = $"../../.."
@onready var ray_cast_3d: RayCast3D = $"../../Marker3D/RayCast3D"
@onready var gun: AnimatedSprite2D = $gun
@onready var text_edit: TextEdit = $TextEdit


var time = 0
var start = false
var shoot = false
var cur_shoot_time = 0




func _process(delta: float) -> void:
	text_edit.text = str(player.pistol_clip,"/",player.pistol_ammo)
	if Input.is_action_pressed("left_click") and not shoot:
		if player.pistol_clip > 0:
			start = false
			cur_shoot_time = 0
			shoot = true
			player.pistol_clip -= 1
			left_click()
			gun.play("shoot")






	if shoot:
		cur_shoot_time += delta
		if cur_shoot_time > shoot_time:
			shoot = false
			gun.play("idle")

	if start:
		time += delta
		if time > 1:
			if player.pistol_ammo+player.pistol_clip >= max_clip:
				player.pistol_ammo += player.pistol_clip
				player.pistol_ammo -= max_clip
				player.pistol_clip = max_clip
			else:
				player.pistol_clip = player.pistol_ammo
				player.pistol_ammo = 0
			gun.play("idle")
			start = false





func _input(event):
	if event.is_action_pressed("reload") and player.pistol_ammo > 0 and player.pistol_clip < max_clip and not shoot:
		start = true
		time = 0
		gun.play("reload")











func spawn(pos: Vector3, normal: Vector3):
	var p = J.instantiate()
	var col = ray_cast_3d.get_collider()
	col.add_sibling(p)
	p.position = pos
	if normal != Vector3.UP:
		# look in the direction of the normal1
		p.look_at(pos + normal, Vector3.UP)
		# then look "up" from there so the decal projects "down"
		p.transform = p.transform.rotated_local(Vector3.RIGHT, PI/2.0)
	p.rotate(normal, randf_range(0, 2*PI))

func left_click():
	if ray_cast_3d.is_colliding():
		spawn(ray_cast_3d.get_collision_point(), ray_cast_3d.get_collision_normal())
		
		if ray_cast_3d.get_collider().has_method("damage"):
			ray_cast_3d.get_collider().damage(hitscn_dmg)
