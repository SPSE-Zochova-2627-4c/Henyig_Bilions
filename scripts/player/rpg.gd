extends Control
const projectile = preload("uid://cu2gewcpqmm25")
const J = preload("uid://uuo0ujb2u4yh")
@onready var player: CharacterBody3D = $"../../.."
@onready var ray_cast_3d: RayCast3D = $"../../Marker3D/RayCast3D"
@onready var rocket_spawn: Node3D = $"../../Marker3D/RocketSpawn"

@onready var gun: AnimatedSprite2D = $gun
@onready var damage_label: Label = $DamageLabel
@onready var ammo_label: Label = $AmmoLabel

@onready var reload_timer: Timer = $"../../../ReloadTimer"
@onready var shoot_cooldown_timer: Timer = $"../../../ShootCooldownTimer"

@export var reload_time: float = 1
@export var shoot_time: float = 0.75
@export var max_clip: int = 4
var shoot = false
var min_dmg = 40
var max_dmg = 100
var real_min_dmg: float = 0
var real_max_dmg: float = 0 

func _ready() -> void:
	reload_timer.stop()
	shoot_cooldown_timer.stop()
	reload_timer.timeout.connect(_on_reload_timer_timeout.bind())
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout.bind())



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	real_max_dmg = max_dmg*player.DMG_MULTIPLYER
	real_min_dmg = real_max_dmg-60
	ammo_label.text = str(player.rpg_clip,"/",player.rpg_ammo)
	damage_label.text = str(int(real_max_dmg)," — ", int(real_min_dmg))
	
	if Input.is_action_pressed("left_click") and not shoot:
		if player.rpg_clip > 0:
			shoot = true
			shoot_cooldown_timer.start(shoot_time)
			player.rpg_clip -= 1
			shoot_projectile()
			gun.play("shoot")







func _on_reload_timer_timeout() -> void:
	if player.rpg_ammo+player.rpg_clip >= max_clip:
		player.rpg_ammo += player.rpg_clip
		player.rpg_ammo -= max_clip
		player.rpg_clip = max_clip
	else:
		player.rpg_clip = player.rpg_ammo
		player.rpg_ammo = 0
	gun.play("idle")

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot = false
	gun.play("idle")

func shoot_projectile():
	var p = projectile.instantiate()
	p.max_expl_dmg = real_max_dmg
	p.min_expl_dmg = real_min_dmg
	p.position = rocket_spawn.global_position
	p.rotation = rocket_spawn.global_rotation
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
		reload_timer.start(reload_time)
		gun.play("reload")
