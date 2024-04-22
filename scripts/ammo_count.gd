## Description: Ammo count script for handling how much ammo the character has left.
## Author: Seth Daniels, Nico Gatapia, Jacob Horton, Elijah Toliver, Gilbert Vandegrift
## Date Created: March 10, 2024
## Date Modified: March 29, 2024
## Version: Development
## Godot Version: 4.2.1
## License: MIT License

extends Label

var pistol_size = 10
var pistol_ammo = 10
var shotgun_size = 6
var shotgun_ammo = shotgun_size
var ammo_count = pistol_size

var reload_status = false
var reload_time = .75
var weapon = 'pistol'

signal swap_weapon()
# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(ammo_count)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if Input.is_action_just_pressed("Shoot"):
		shoot()

	if Input.is_action_just_pressed("Reload"):
		reload()
	if Input.is_action_just_pressed('Swap_Weapon'):
		swap()
	
		
		
func done_reload():
	if weapon == 'pistol':
		ammo_count = pistol_size
	if weapon == 'shotgun':
		ammo_count = shotgun_size
	text = str(ammo_count)
	reload_status = false

func shoot():
	if ammo_count > 0:
		if reload_status:
			pass
		else:
			ammo_count -= 1
			if ammo_count == 0:
				reload()
	else:
		reload()
	text = str(ammo_count)
func reload():
	reload_status = true
	get_tree().create_timer(reload_time, false).timeout.connect(func(): done_reload())
	
func swap():
	if weapon == 'pistol':
		pistol_ammo = ammo_count
		ammo_count = shotgun_ammo
		weapon = 'shotgun'
	if weapon == 'shotgun':
		shotgun_ammo = ammo_count
		ammo_count = pistol_ammo
		weapon = 'pistol'
	print(weapon)
	print(ammo_count)
	text = str(ammo_count)
