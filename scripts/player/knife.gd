extends Control

@onready var area_3d: Area3D = $"../../Area3D"
 
const max_clip: int = 8


@export var dmg: int = 100
@export var shoot_time: float = 0.25

@onready var player: CharacterBody3D = $"../../.."
@onready var gun: AnimatedSprite2D = $gun


var time = 0
var shoot = false
var cur_shoot_time = 0




func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click") and not shoot:
		cur_shoot_time = 0
		shoot = true

		cut()
		gun.play("shoot")



	if shoot:
		cur_shoot_time += delta
		if cur_shoot_time > shoot_time:
			shoot = false
			gun.play("idle")

func cut():
	#if area_3d.has_overlapping_bodies():
		for body in area_3d.get_overlapping_bodies():
			if body.has_method("damage"):
				body.damage(dmg,0,player.global_position,false)
