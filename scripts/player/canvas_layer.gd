extends CanvasLayer
@onready var player: CharacterBody3D = $"../.."
@onready var speed: Label = $Speed
@onready var Score: Label = $Score
@onready var heart: AnimatedSprite2D = $Heart
@onready var blood_level: TextureProgressBar = $BloodLevel
@onready var hp_pct: Label = $HPpct
@onready var eta_0: Label = $ETA0

@onready var blood_spawn_point: Node3D = $"../../BloodPoint"






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	hp_pct.text = str(snapped(0.2*player.hp,0.01),"%")
	if blood_spawn_point.get_child_count():
		eta_0.visible = true
		eta_0.text = str("0 IN\n",snapped(player.hp/(3*blood_spawn_point.get_child_count()),0.01))
	else:
		eta_0.visible = false
	blood_level.value = player.hp/5
	var player_speed = sqrt(player.velocity.x**2+player.velocity.y**2+player.velocity.z**2)
	speed.text = str(snapped(player_speed,0.0001))
	
	
	
	var score = ""
	for i in range(9-len(str(player.SCORE))):
		score += "0  "
	for i in str(player.SCORE):
		score += i
		score += "  "
	score = score.rstrip(" ")
	Score.text = score
