extends Control

@onready var item: AnimatedSprite2D = $item
@onready var damage_label: Label = $DamageLabel
@onready var ammo_label: Label = $AmmoLabel
@onready var player: CharacterBody3D = $"../../.."

@export var shoot_time: float = 2
var shoot = false
var cur_shoot_time = 0
@onready var shoot_cooldown_timer: Timer = $"../../../ShootCooldownTimer"

func _ready() -> void:
	shoot_cooldown_timer.stop()
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout.bind())

func _on_shoot_cooldown_timer_timeout() -> void:
	player.hp += 50
	shoot = false
	item.play("idle")

func _process(_delta: float) -> void:
	ammo_label.text = str(5)
	damage_label.text = str("+50 HP")
	if Input.is_action_pressed("left_click") and not shoot:
			left_click()
			item.play("shoot")


func left_click():
	shoot = true
	shoot_cooldown_timer.start(shoot_time)
	
