extends Control

const J = preload("uid://uuo0ujb2u4yh")

const max_clip: int = 8


@export var hitscn_dmg: int = 40
@export var shoot_time: float = 0.25
@export var reload_time: float = 1

@onready var player: CharacterBody3D = $"../../.."
@onready var ray_cast_3d: RayCast3D = $"../../Marker3D/RayCast3D"
@onready var gun: AnimatedSprite2D = $gun
@onready var ammo_label: Label = $AmmoLabel
@onready var damage_label: Label = $DamageLabel




var shoot = false
var real_dmg: float = 0

@onready var reload_timer: Timer = $"../../../ReloadTimer"
@onready var shoot_cooldown_timer: Timer = $"../../../ShootCooldownTimer"
func _ready() -> void:
	reload_timer.stop()
	shoot_cooldown_timer.stop()
	reload_timer.timeout.connect(_on_reload_timer_timeout.bind())
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout.bind())
	
func _on_reload_timer_timeout() -> void:
	if player.pistol_ammo+player.pistol_clip >= max_clip:
		player.pistol_ammo += player.pistol_clip
		player.pistol_ammo -= max_clip
		player.pistol_clip = max_clip
	else:
		player.pistol_clip = player.pistol_ammo
		player.pistol_ammo = 0
	gun.play("idle")

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot = false
	gun.play("idle")

func _process(_delta: float) -> void:
	real_dmg = hitscn_dmg*player.DMG_MULTIPLYER
	ammo_label.text = str(player.pistol_clip,"/",player.pistol_ammo)
	damage_label.text = str(int(real_dmg))
	
	if Input.is_action_pressed("left_click") and not shoot:
		if player.pistol_clip > 0:
			shoot = true
			player.pistol_clip -= 1
			left_click()
			gun.play("shoot")





func _input(event):
	if event.is_action_pressed("reload") and player.pistol_ammo > 0 and player.pistol_clip < max_clip and not shoot:
		reload_timer.start(reload_time)
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
	shoot_cooldown_timer.start(shoot_time)
	if ray_cast_3d.is_colliding():
		spawn(ray_cast_3d.get_collision_point(), ray_cast_3d.get_collision_normal())
		if ray_cast_3d.get_collider().has_method("damage"):
			ray_cast_3d.get_collider().damage(real_dmg,0,player.global_position,ray_cast_3d.get_collision_point())
		
