extends Node2D

@onready var fish_pl = preload("res://scenes/fish.tscn")

var delay = 2.0

func _ready():
	pass # Replace with function body.

func spawn():
	var fish = fish_pl.instantiate()
	fish.global_position = Vector2(-16, randf_range(30, 110))
	add_child(fish)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	spawn()
	$Timer.start(delay)
