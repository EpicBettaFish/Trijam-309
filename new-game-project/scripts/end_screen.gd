extends Node2D
var score = Singleton.score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Highscorelabel.text = "Highscore: %07d" % (Singleton.score * 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		Singleton.reset()
	#if Input.is_action_just_pressed("scopeIn"):
	#	get_tree().quit()
