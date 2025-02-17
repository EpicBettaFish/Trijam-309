extends Control
signal updateValues

@onready var main: Node2D = $"../.."

@onready var fr_price: Label = $Perma/FireRate/FRPrice
@onready var su_price: Label = $Perma/SpotterCooldown/SUPrice
@onready var sc_price: Label = $Perma/ScanCooldown/SCPrice

@onready var sr_price: Label = $One/ScanRadius/SRPrice
@onready var gg_price: Label = $One/GoonGunner/GGPrice
@onready var gs_price: Label = $One/GoonSpotter/GSPrice











var fire_rate_cost = 5
var spotter_cooldown_cost = 5
var scan_cooldown_cost = 7 #scan uptime
var scan_radius_cost = 10
var goon_cost = 10



	
func _process(delta: float) -> void:
	fr_price.text = str(fire_rate_cost)
	su_price.text = str(spotter_cooldown_cost)
	sc_price.text = str(scan_cooldown_cost)
	
	sr_price.text = str(scan_radius_cost)
	gg_price.text = str(goon_cost)
	gs_price.text = str(goon_cost)
	if Input.is_action_just_pressed("toggleShop"):
		visible = !visible
		
		

func _on_fire_rate_button_up() -> void:
	if Singleton.money >= fire_rate_cost:
		Singleton.fire_rate_upgrade += 1
		emit_signal("updateValues")
		fire_rate_cost = round(fire_rate_cost * 1.15)
		
func _on_spotter_cooldown_button_up() -> void:
	if Singleton.money >= spotter_cooldown_cost:
		Singleton.spotter_cooldown_upgrade += 1
		emit_signal("updateValues")
		spotter_cooldown_cost = round(spotter_cooldown_cost * 1.15)

func _on_scan_cooldown_button_up() -> void:
	if Singleton.money >= scan_cooldown_cost:
		Singleton.scan_cooldown_upgrade += 1
		emit_signal("updateValues")
		scan_cooldown_cost = round(scan_cooldown_cost * 1.15)


func _on_scan_radius_button_up() -> void:
	if Singleton.money >= scan_radius_cost:
		Singleton.scan_radius_upgrade = true
		emit_signal("updateValues")
		scan_radius_cost = round(scan_radius_cost * 1.15)
	
func _on_goon_press(type):
	if Singleton.money >= goon_cost:
		main.attemptSpawn(type)
		goon_cost = round(goon_cost * 1.15)
