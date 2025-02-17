extends Node2D
@onready var reticle = $Control/aimreticle
@onready var mouse = false
@onready var soundsniper = "res://assets/audio/SniperSound.ogg"
@onready var mousepos = get_viewport().get_mouse_position()
var mouseaim = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mousepos = get_viewport().get_mouse_position()
	reticle.position.x = mousepos.x
	reticle.position.y = mousepos.y
	if mouse == true:
		reticle.visible = true
		reticle.position.x = mousepos.x
		reticle.position.y = mousepos.y
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
			
	if not mouse:
		reticle.visible = false
	
	


func _on_area_2d_mouse_entered() -> void: 
	mouse = true
	
	


func _on_area_2d_mouse_exited() -> void:
	mouse = false
