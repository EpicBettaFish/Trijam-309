extends Area2D

@onready var fishSprite: Sprite2D = $FishSprite
@onready var fishScanSprite: Sprite2D = $ScanFish/ScanColor


var life = 1
@export var screams: Array[AudioStream]

var base_y = 0.0
var speed = 6.0
var t_bob = 0.0
var t_increase = 1.0
var enemy: bool = false
var scanColor: Color = Color(0.3,0.75,0.3)

func _ready():
	$ScreamAudio.pitch_scale = randf_range(1.11, 1.33)
	base_y = global_position.y
	speed *= randf_range(0.92, 1.11)
	t_increase *= randf_range(0.92, 2.11)
	var isEnemy = randi_range(1,3)
	if isEnemy <= 2:
		enemy = true
		scanColor = Color(0.75,0.3,0.3)
	
	
	fishSprite.modulate.r = randf_range(0.25,0.80)
	fishSprite.modulate.g = randf_range(0.25,0.80)
	fishSprite.modulate.b = randf_range(0.25,1)
	
	fishScanSprite.modulate = fishSprite.modulate

func become(fish_to_be):
	match fish_to_be:
		"shark":
			$FishSprite.texture = load("res://assets/sprites/shark.png")
			$ScanFish/ScanColor.texture = load("res://assets/sprites/shark_scan.png")
			$ScanFish/ScanSkeleton.texture = load("res://assets/sprites/shark_skeleton.png")
			$CollisionShape2D.shape.size = Vector2(46, 16)
			$ScreamAudio.pitch_scale = randf_range(0.57, 0.75)
			life = 12
		"swordfish":
			$FishSprite.texture = load("res://assets/sprites/swordfish.png")
			$ScanFish/ScanColor.texture = load("res://assets/sprites/swordfish_scan.png")
			$ScanFish/ScanSkeleton.texture = load("res://assets/sprites/swordfish_skeleton.png")
			$CollisionShape2D.shape.size = Vector2(30, 8)
			$ScreamAudio.pitch_scale = randf_range(0.82, 1.1)
			life = 4
			

func _process(delta):
	t_bob += t_increase*delta
	global_position.x += speed*delta
	global_position.y = base_y + (sin(t_bob)*3)

func hit():
	life -= 1
	if life < 1:
		var scream_audio = $ScreamAudio
		screams.shuffle()
		scream_audio.stream = screams[0]
		scream_audio.play()
		remove_child(scream_audio)
		get_tree().current_scene.add_child(scream_audio)
		get_parent().spawned_fish.erase(self)
		get_parent().evil_fish.erase(self)
		
		##GIVE SHOP MONEY HERE
		
		queue_free()

func _on_area_entered(area):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(fishSprite, "modulate", scanColor, 0.5)
	tween.parallel().tween_property(fishScanSprite, "modulate", scanColor, 0.5)
	if enemy and get_parent().evil_fish.count(self) == 0: get_parent().evil_fish.append(self)
	get_parent().spawned_fish.erase(self)
