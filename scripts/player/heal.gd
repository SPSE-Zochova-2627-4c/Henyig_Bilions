extends Control

@onready var item: AnimatedSprite2D = $item
@onready var damage_label: Label = $DamageLabel
@onready var ammo_label: Label = $AmmoLabel
@onready var player: CharacterBody3D = $"../../.."

@export var shoot_time: float = 2
var shoot = false
var cur_shoot_time = 0

func _process(delta: float) -> void:
	ammo_label.text = str(5)
	damage_label.text = str("+50 HP")
	if Input.is_action_pressed("left_click") and not shoot:
			left_click()
			item.play("shoot")
			
	if shoot:
		cur_shoot_time += delta
		if cur_shoot_time > shoot_time:
			shoot = false
			item.play("idle")
			
func left_click():
	shoot = true
	cur_shoot_time = 0
	player.hp += 50
