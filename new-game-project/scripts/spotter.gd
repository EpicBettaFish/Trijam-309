extends Node2D

@onready var spawner = get_tree().current_scene.get_node("FishSpawner")

var spotterScan = preload("res://scenes/spotterScan.tscn")

func _ready():
	await get_tree().create_timer(5).timeout
	$ScanTimer.start()

func _on_scan_timer_timeout():
	if !spawner.spawned_fish.is_empty():
		var fish = spawner.spawned_fish.front()
		
		var newScan = spotterScan.instantiate()
		newScan.global_position = fish.global_position
		get_parent().add_child(newScan)
