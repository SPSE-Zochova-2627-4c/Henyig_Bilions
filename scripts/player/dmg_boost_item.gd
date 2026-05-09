extends Control
@onready var item: AnimatedSprite2D = $item
@onready var damage_label: Label = $DamageLabel
@onready var ammo_label: Label = $AmmoLabel
@onready var player: CharacterBody3D = $"../../.."

@onready var invslot: Resource
@onready var slot_num: int

@export var shoot_time: float = 3
var shoot = false
@onready var shoot_cooldown_timer: Timer = $"../../../ShootCooldownTimer"
@onready var inv_control: Control = $"../InvControl"

func _ready() -> void:
	shoot_cooldown_timer.stop()
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout.bind())

func _on_shoot_cooldown_timer_timeout() -> void:
	player.DMG_MULTIPLYER *= 2
	invslot.amount -= 1
	if invslot.amount <= 0:
		kill_myself()
	shoot = false
	item.play("idle")

func _process(_delta: float) -> void:
	ammo_label.text = str(invslot.amount)
	damage_label.text = str("2X DMG")
	if Input.is_action_pressed("left_click") and not shoot:
			left_click()
			item.play("shoot")


func kill_myself():
	inv_control.clear_slot(slot_num)
	queue_free()
		
func set_slot(slot,num):
	invslot = slot
	slot_num = num

func left_click():
	shoot = true
	shoot_cooldown_timer.start(shoot_time)
	
