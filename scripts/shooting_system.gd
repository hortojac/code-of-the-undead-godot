## Description: Shooting system script for shooting bullets.
## Author: Seth Daniels, Nico Gatapia, Jacob Horton, Elijah Toliver, Gilbert Vandegrift
## Date Created: March 10, 2024
## Date Modified: March 31, 2024
## Version: Development
## Godot Version: 4.2.1
## License: MIT License

extends Marker2D


class_name ShootingSystem

signal shot(pistol_ammo: int)
signal gun_reload(pistol_ammo: int, ammo_left: int)
var reload_time = 1
var reload_status = false
var equipped = false
var weapon = 'pistol'

@export var pistol_size = 10
@export var pistol_ammo = 10

var shotgun_size = 6
var shotgun_ammo = 6

@onready var bullet_scene = preload("res://scenes/bullet.tscn")
func _ready():
	pistol_ammo = pistol_size
	
func _input(event):
	if Input.is_action_just_pressed("Shoot"):
		shoot()
	if Input.is_action_just_pressed("Reload"):
		reload()
	if Input.is_action_just_pressed("Shoot_Toggle"):
		equipped = not equipped
	if Input.is_action_just_pressed("Swap_Weapon"):
		if equipped:
			if weapon == 'pistol':
				weapon = 'shotgun'
			else:
				weapon = 'pistol'
func reload():
	if equipped:
		if reload_status == true:
			return
		$Reload.play()
		print('reloading')
		reload_status = true
		if weapon == 'pistol':
			pistol_ammo = pistol_size
		if weapon == 'shotgun':
			shotgun_ammo = shotgun_size
		get_tree().create_timer(reload_time, false).timeout.connect(func(): reload_status = false)
	
func shoot():
	if equipped:
		if pistol_ammo <= 0 or reload_status == true:
			reload()
			return
		else:
			if weapon == 'pistol':
				$PistolShot.play()
				var bullet = bullet_scene.instantiate() as Bullet
				get_tree().root.add_child(bullet)
				var move_direction = (get_global_mouse_position() - global_position).normalized()
				bullet.move_direction = move_direction
				bullet.global_position = global_position
				bullet.rotation = move_direction.angle()
				pistol_ammo -= 1
				emit_signal('shot')
				if pistol_ammo == 0:
					reload()
			if weapon == 'shotgun':
				$ShotgunShot.play()
				var spread_angle = 10 # Angle in degrees for the spread between bullets
				var bullet_count = 3 # Total number of bullets to shoot

				for i in range(bullet_count):
					var bullet = bullet_scene.instantiate() as Bullet
					get_tree().root.add_child(bullet)
					
					# Calculate the angle offset for each bullet
					var angle_offset = deg_to_rad(spread_angle * (i - (bullet_count - 1) / 2))
					
					# Calculate the move direction with the angle offset
					var move_direction = (get_global_mouse_position() - global_position).normalized().rotated(angle_offset)
					
					bullet.move_direction = move_direction
					bullet.global_position = global_position
					bullet.rotation = move_direction.angle()

				shotgun_ammo -= 1
				emit_signal('shot')
				if shotgun_ammo == 0:
					reload()
	
# https://www.youtube.com/watch?v=nqaSLUdEPL0
