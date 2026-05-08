extends Control
@onready var inv_gun: Control = $InvGun
@onready var item_inventory: Control = $ItemInventory

@onready var inventory: Inventory = preload("uid://cbxxfhkuhs0kl")

@onready var gun_slots: Array = inv_gun.get_child(-1).get_children()
@onready var itm_slots: Array = item_inventory.get_child(-1).get_children()


@onready var canvas_layer: CanvasLayer = $".."
@onready var weapon_list = [null,null,null,null,null]
@onready var item_list = [null,null,null,null,null,null,null,null,null,null]


var hand = preload("uid://c31fi4iayokx6")


var in_hand = hand.instantiate()


var slot_selected = null

func _ready() -> void:
	update_slots()
	add_child(in_hand)
	slot_selected = gun_slots[1]

func update_slots():
	for slot in range(gun_slots.size()):
		gun_slots[slot].update(inventory.items[slot])
		if inventory.items[slot]:
			weapon_list[slot] = load(inventory.items[slot].uid)
			
	for slot in range(gun_slots.size(),itm_slots.size()+gun_slots.size()):
		itm_slots[slot-5].update(inventory.items[slot])
		if inventory.items[slot]:
			item_list[slot-5] = load(inventory.items[slot].uid)




func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("quick_switch"):
		#var values = [prev_hand_scene, in_hand_scene]
		#swap(values)
		#swap_to(prev_hand_scene)
		
	if event.is_action_pressed("1"):
		swap_to_w(1)
	
	if event.is_action_pressed("2"):
		swap_to_w(2)

	if event.is_action_pressed("3"):
		swap_to_w(3)
	
	if event.is_action_pressed("4"):
		swap_to_w(4)
		
	if event.is_action_pressed("5"):
		swap_to_w(5)

	if event.is_action_pressed("6"):
		swap_to_i(1)
	
	if event.is_action_pressed("7"):
		swap_to_i(2)

	if event.is_action_pressed("8"):
		swap_to_i(3)
	
	if event.is_action_pressed("9"):
		swap_to_i(4)
		
	if event.is_action_pressed("10"):
		swap_to_i(5)

	if event.is_action_pressed("11"):
		swap_to_i(6)
	
	if event.is_action_pressed("12"):
		swap_to_i(7)

	if event.is_action_pressed("13"):
		swap_to_i(8)
	
	if event.is_action_pressed("14"):
		swap_to_i(9)
		
	if event.is_action_pressed("15"):
		swap_to_i(10)
	

func swap_to_w(n):
	if weapon_list[n-1]:
		slot_selected.deselect()
		in_hand.queue_free()
		in_hand = weapon_list[n-1].instantiate()
		canvas_layer.add_child(in_hand)
		slot_selected = gun_slots[n-1]
		slot_selected.select()

func swap_to_i(n):
	if item_list[n-1]:
		slot_selected.deselect()
		in_hand.queue_free()
		in_hand = item_list[n-1].instantiate()
		canvas_layer.add_child(in_hand)
		slot_selected = itm_slots[n-1]
		slot_selected.select()

func swap(arr):
	var j = arr[0]
	arr[0] = arr[1]
	arr[1] = j
