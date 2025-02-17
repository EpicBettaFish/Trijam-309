extends Node2D
@onready var mouse = false
@onready var soundsniper = "res://assets/audio/SniperSound.ogg"
@onready var mousepos = get_viewport().get_mouse_position()
var mouseaim = true

var infish2 = false
var infish3 = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Control/Part 2".hide()
	$"Control/Part 3".hide()
	$"Control/Part 4".hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mousepos = get_viewport().get_mouse_position()
	if mouse == true:
		if Input.is_action_just_pressed("shoot") == true and mouseaim:
			mouseaim = false
			var sprite2d2 = Sprite2D.new()
			add_child(sprite2d2)
			sprite2d2.texture = load("res://assets/sprites/introbullet.png")
			sprite2d2.position.x = mousepos.x
			sprite2d2.position.y = mousepos.y
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(4).timeout
			get_tree().change_scene_to_file("res://scenes/main.tscn")
			
	
	

func _unhandled_input(event):
	if event.is_action_pressed("scopeIn") and infish2:
		$"Control/Part 2".queue_free()
		$"Control/Part 3".show()
		$ding.play()
		infish2 = false
	if event.is_action_pressed("shoot") and infish3:
		$ding.play()
		$"Control/Part 3".queue_free()
		infish3 = false
		$"Control/Part 4".show()


func _on_area_2d_mouse_entered() -> void: 
	mouse = true
	
	


func _on_area_2d_mouse_exited() -> void:
	mouse = false


func _on_aimoverfish_mouse_entered():
	$ding.play()
	$"Control/Part 1/Sprite2D/aimoverfish".queue_free()
	$"Control/Part 1".hide()
	$"Control/Part 2".show()


func _on_scan_detect_mouse_entered():
	infish2 = true


func _on_scan_detect_mouse_exited():
	infish2 = false


func _on_shoot_detect_mouse_entered():
	infish3 = true


func _on_shoot_detect_mouse_exited():
	infish3 = false
