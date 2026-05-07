extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/item
@onready var bg: Sprite2D = $bg

var bg_color = preload("uid://c5n0kvvrthjpo")
var bg_color_select = preload("uid://bh4o4y11kthhy")



func update(item: InventoryItem):
	if !item:
		item_sprite.visible = false
	else:
		item_sprite.texture = item.texture
		item_sprite.apply_scale(Vector2(0.1,0.1))
		item_sprite.visible = true

func select():
	bg.texture = bg_color_select
	
func deselect():
	bg.texture = bg_color
