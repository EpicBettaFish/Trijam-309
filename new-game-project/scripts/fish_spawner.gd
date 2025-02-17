extends Node2D

@onready var fish_pl = preload("res://scenes/fish.tscn")

var cycles = 0

var delay = 2.0

func _ready():
	pass # Replace with function body.

func spawn():
	var fish = fish_pl.instantiate()
	fish.global_position = Vector2(-16, randf_range(30, 110))
	
	fish.become("swordfish")
	
	add_child(fish)
	if cycles > 30:
		var roll = randi_range(1, 20)
		if roll < 3 && cycles > 120:
			fish.become("shark")
		elif roll < 6:
			fish.become("swordfish")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	cycles += 1
	spawn()
	$Timer.start(delay)
