extends Node2D

@onready var spawner = get_tree().current_scene.get_node("FishSpawner")


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fire_timer_timeout():
	if !spawner.evil_fish.is_empty():
		spawner.evil_fish.front().hit()
		$AudioStreamPlayer2D.play()
		$Sprite2D.frame = 1
		await get_tree().create_timer(0.2).timeout
		$Sprite2D.frame = 0
