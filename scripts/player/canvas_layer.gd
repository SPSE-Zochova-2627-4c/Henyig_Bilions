extends CanvasLayer
@onready var player: CharacterBody3D = $"../.."
@onready var speed: Label = $Speed
@onready var SCORE: int = 0
@onready var Score: Label = $Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed.text = str(player.velocity)
	var score = ""
	for i in range(9-len(str(SCORE))):
		score += "0  "
	for i in str(SCORE):
		score += i
		score += "  "
	score = score.rstrip(" ")
	Score.text = score
