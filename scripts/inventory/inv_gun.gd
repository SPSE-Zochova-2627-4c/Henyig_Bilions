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
	add_item(load("res://scripts/inventory/items/knife_item.tres"),1)
	add_item(load("res://scripts/inventory/items/pistol_item.tres"),1)
	add_item(load("res://scripts/inventory/items/rpg_item.tres"),1)
	add_item(load("res://scripts/inventory/items/bandage_item.tres"),5)
	add_item(load("res://scripts/inventory/items/heal_item.tres"),5)

	add_child(in_hand)
	slot_selected = gun_slots[1]
	
func add_item(itm,amount):
	var in_inv = false
	for i in range(inventory.slots.size()):
		if inventory.slots[i].item == itm:
			in_inv = true
	if itm.is_weapon and not in_inv:
		for i in range(5):
			if not inventory.slots[i].item:
				inventory.slots[i].item = itm
				break
	elif not in_inv:
		for i in range(10):
			if not inventory.slots[i+5].item:
				inventory.slots[i+5].item = itm
				inventory.slots[i+5].amount = amount
				break
	else:
		for i in range(10):
			if inventory.slots[i+5].item == itm:
				inventory.slots[i+5].amount += amount
				break
	update_slots()

func update_slots():
	for i in range(gun_slots.size()):
		gun_slots[i].update(inventory.slots[i].item)
		if inventory.slots[i].item:
			weapon_list[i] = load(inventory.slots[i].item.uid)
		else:
			weapon_list[i] = null
			
	for i in range(gun_slots.size(),itm_slots.size()+gun_slots.size()):
		itm_slots[i-5].update(inventory.slots[i].item)
		if inventory.slots[i].item:
			item_list[i-5] = load(inventory.slots[i].item.uid)
		else:
			item_list[i-5] = null

func clear_slot(num):
	inventory.slots[num].item = null
	update_slots()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_switch"):
		print(inventory.slots[5].amount)
		update_slots()
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
		if in_hand:
			in_hand.queue_free()
		in_hand = weapon_list[n-1].instantiate()
		canvas_layer.add_child(in_hand)
		slot_selected = gun_slots[n-1]
		slot_selected.select()

func swap_to_i(n):
	if item_list[n-1]:
		slot_selected.deselect()
		if in_hand:
			in_hand.queue_free()
		in_hand = item_list[n-1].instantiate()
		in_hand.set_slot(inventory.slots[n+4],n+4)
		canvas_layer.add_child(in_hand)
		slot_selected = itm_slots[n-1]
		slot_selected.select()

func swap(arr):
	var j = arr[0]
	arr[0] = arr[1]
	arr[1] = j
