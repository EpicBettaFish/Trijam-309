extends Node2D

var health: int = 10
@onready var healthLabel = $UI/Health

@onready var minionParent = $Minions
@onready var spotterSpawns = $Spawns/SpotterSpawns
@onready var goonSpawns = $Spawns/GoonSpawns

var activeSpotters = 0
var activeGoons = 0

#MINIONS
var goon = preload("res://scenes/goon.tscn")
var spotter = preload("res://scenes/spotter.tscn")

func _ready():
	attemptSpawn("goon")

func damage(amount) -> void:
	health -= 1
	healthLabel.text = str(health)

func _unhandled_input(event):
	if event.is_action_pressed("DEBUG"):
		damage(1)

func _on_tower_entrance_area_entered(area):
	if area.enemy:
		damage(1)
	area.queue_free()

func attemptSpawn(minionType) -> void:
	var newMinion
	var spawns
	
	match minionType:
		"goon":
			if activeGoons >= 5:
				return
			newMinion = goon.instantiate()
			spawns = goonSpawns.get_children()
			newMinion.global_position = spawns[activeGoons].global_position
			activeGoons += 1
		"spotter":
			if activeSpotters >= 5:
				return
			newMinion = spotter.instantiate()
			spawns = spotterSpawns.get_children()
			newMinion.global_position = spawns[activeSpotters].global_position
			activeSpotters += 1
	
	minionParent.add_child(newMinion)
