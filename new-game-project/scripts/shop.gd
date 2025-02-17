extends Control
signal updateValues

@onready var main: Node2D = $"../.."

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggleShop"):
		visible = !visible


func _on_fire_rate_button_up() -> void:
	Singleton.fire_rate_upgrade += 1
	emit_signal("updateValues")
	
func _on_spotter_cooldown_button_up() -> void:
	Singleton.spotter_cooldown_upgrade += 1
	emit_signal("updateValues")


func _on_scan_cooldown_button_up() -> void:
	Singleton.scan_cooldown_upgrade += 1
	emit_signal("updateValues")



func _on_scan_radius_button_up() -> void:
	Singleton.scan_radius_upgrade = true
	emit_signal("updateValues")

	
func _on_goon_press(type):
	main.attemptSpawn(type)
