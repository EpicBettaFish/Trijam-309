extends Node

var money: int = 0
var score = 0

var fire_rate_upgrade: int
var spotter_cooldown_upgrade: int
var scan_cooldown_upgrade: int
var scan_radius_upgrade: bool

func reset():
	score = 0
	money = 0
	fire_rate_upgrade = 0
	spotter_cooldown_upgrade = 0
	scan_cooldown_upgrade = 0
	scan_radius_upgrade = false
