extends Node2D

var health: int = 10
@onready var healthLabel = $UI/Health

@onready var minionParent = $Minions
@onready var spotterSpawns = $Spawns/SpotterSpawns
@onready var goonSpawns = $Spawns/GoonSpawns

@onready var moneyLabel = $UI/Money
@onready var scoreLabel = $UI/Score

@onready var gun = $Gun

@onready var explosionAnim = $explode

var activeSpotters = 0
var activeGoons = 0

#MINIONS
var goon = preload("res://scenes/goon.tscn")
var spotter = preload("res://scenes/spotter.tscn")

func damage(amount) -> void:
	if health != 0:
		health -= 1
		healthLabel.text = str(health)
	if health == 0:
		explosionAnim.play("splosionend")
	elif health > 0:
		explosionAnim.play("splosion")

func _process(delta):
	moneyLabel.text = "$%0.2f" % Singleton.money
	scoreLabel.text = "score: %07d" % (Singleton.score * 100)

func _unhandled_input(event):
	if event.is_action_pressed("DEBUG"):
		damage(1)

func _on_tower_entrance_area_entered(area):
	if area.enemy:
		damage(1)
	else:
		Singleton.money += 0.5
		Singleton.score += 0.5
	area.die()

func attemptSpawn(minionType) -> void:
	var newMinion
	var spawns
	
	match minionType:
		"gunner":
			newMinion = goon.instantiate()
			spawns = goonSpawns.get_children()
			if activeGoons >= 5:
				newMinion.global_position = spawns[6].global_position
			else:
				newMinion.global_position = spawns[activeGoons].global_position
			activeGoons += 1
		"spotter":
			if activeSpotters >= 5:
				return
			newMinion = spotter.instantiate()
			spawns = spotterSpawns.get_children()
			if activeSpotters >= 5:
				newMinion.global_position = spawns[6].global_position
			else:
				newMinion.global_position = spawns[activeSpotters].global_position
			activeSpotters += 1
	
	minionParent.add_child(newMinion)


func _on_explode_animation_finished(anim_name):
	if anim_name == "splosionend":
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
