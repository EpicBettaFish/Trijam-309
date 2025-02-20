extends Node2D

@onready var fish_pl = preload("res://scenes/fish.tscn")

var cycles = 0


var delay = 2.5

var spawned_fish = []
var evil_fish = []

func _ready():
	pass # Replace with function body.

func spawn():
	var fish = fish_pl.instantiate()
	fish.global_position = Vector2(-16, randf_range(30, 110))
	
	
	add_child(fish)
	if cycles > 30:
		var roll = randi_range(1, 20)
		if roll < 3 && cycles > 100:
			fish.become("shark")
		elif roll < 5:
			fish.become("swordfish")
	
	spawned_fish.append(fish)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var timer_delay:float = clamp(cycles / 100, 0.0, 2.0)
	cycles += 1
	spawn()
	$Timer.start(delay - timer_delay)
