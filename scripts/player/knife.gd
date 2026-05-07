extends Control

@onready var area_3d: Area3D = $"../../Area3D"
 
const max_clip: int = 8


@export var dmg: int = 100
@export var shoot_time: float = 0.25

@onready var player: CharacterBody3D = $"../../.."
@onready var gun: AnimatedSprite2D = $gun

@onready var shoot_cooldown_timer: Timer = $"../../../ShootCooldownTimer"

func _ready() -> void:
	shoot_cooldown_timer.stop()
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout.bind())


func _on_shoot_cooldown_timer_timeout() -> void:
	shoot = false
	gun.play("idle")

var time = 0
var shoot = false
var cur_shoot_time = 0

@onready var real_dmg: float = 0



func _process(_delta: float) -> void:
	real_dmg = dmg*player.DMG_MULTIPLYER
	if Input.is_action_pressed("left_click") and not shoot:
		cur_shoot_time = 0
		shoot = true

		cut()
		gun.play("shoot")


func cut():
	#if area_3d.has_overlapping_bodies():
		shoot_cooldown_timer.start(shoot_time)
		for body in area_3d.get_overlapping_bodies():
			if body.has_method("damage"):
				body.damage(real_dmg,0,player.global_position,false)
