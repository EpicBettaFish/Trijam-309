extends Node2D

var health: int = 10
@onready var healthLabel = $UI/Health

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
