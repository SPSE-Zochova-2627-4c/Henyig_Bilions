extends Control

@onready var inventory: Inventory = preload("uid://cbxxfhkuhs0kl")
@onready var inv_slots: Array = $GridContainer.get_children()
@onready var canvas_layer: CanvasLayer = $".."
@onready var weapon_list = [null,null,null,null,null]

var pistol = preload("uid://dureo6lwixg0")
var hand = preload("uid://c31fi4iayokx6")
var RPG = preload("uid://jcobrh6oadkh")
var KNIFE = preload("uid://dfvk5kghbnrnb")

var in_hand = hand.instantiate()
var in_hand_scene = 1
var prev_hand_scene = 1



func _ready() -> void:
	update_slots()
	add_child(in_hand)

func update_slots():
	for slot in range(min(inventory.items.size(),inv_slots.size())):
		inv_slots[slot].update(inventory.items[slot])
		if inventory.items[slot]:
			weapon_list[slot] = load(inventory.items[slot].uid)




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_switch"):
		in_hand.queue_free()
		in_hand = prev_hand_scene.instantiate()
		var values = [prev_hand_scene, in_hand_scene]
		swap(values)
		prev_hand_scene = values[0]
		in_hand_scene = values[1]
		canvas_layer.add_child(in_hand)
		
	if event.is_action_pressed("1"):
		swap_to(1)
		
		
	if event.is_action_pressed("2"):
		swap_to(2)

	if event.is_action_pressed("3"):
		swap_to(3)

func swap_to(n):
	if weapon_list[n-1]:
		inv_slots[in_hand_scene-1].deselect()
		prev_hand_scene = in_hand_scene
		in_hand_scene = n
		in_hand.queue_free()
		in_hand = weapon_list[n-1].instantiate()
		canvas_layer.add_child(in_hand)
		inv_slots[n-1].select()

func swap(arr):
	var j = arr[0]
	arr[0] = arr[1]
	arr[1] = j
