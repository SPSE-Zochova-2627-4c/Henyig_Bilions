extends Node2D
@onready var line_2d: Line2D = $Line2D
@onready var heart: AnimatedSprite2D = $"../Heart"
@onready var player: CharacterBody3D = $"../../.."
@onready var change: bool = false
@export var def_beat_size = 20




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for point in range(line_2d.get_point_count()):
		line_2d.points[point].x -= 50*delta
		
	for point in range(line_2d.get_point_count()):
		if line_2d.get_point_count() >= 2 and line_2d.points[0].x < 0 and line_2d.points[1].x < 0:
			line_2d.remove_point(0)
		elif line_2d.get_point_count() < 2 and line_2d.points[0].x < 0:
			line_2d.remove_point(0)
			
	if heart.frame_changed:
		if heart.get_frame() == 0:
			change = true
			line_2d.add_point(Vector2(100,50-min(def_beat_size*player.DMG_MULTIPLYER,50)))
		elif heart.get_frame() == 4:
			change = false
			line_2d.add_point(Vector2(100,50+min(def_beat_size*player.DMG_MULTIPLYER,50)))
		elif not change:
			line_2d.add_point(Vector2(100,50))
	elif not change:
		line_2d.add_point(Vector2(100,50))

	
		
