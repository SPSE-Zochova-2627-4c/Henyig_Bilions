extends CanvasLayer
@onready var player: CharacterBody3D = $"../.."
@onready var speed: Label = $Speed
@onready var Score: Label = $Score
@onready var heart: AnimatedSprite2D = $Heart
@onready var blood_level: TextureProgressBar = $BloodLevel






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
