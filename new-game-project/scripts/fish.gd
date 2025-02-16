extends Area2D

@onready var fishSprite: Sprite2D = $FishSprite
@onready var fishScanSprite: Sprite2D = $ScanFish/ScanColor

var enemy: bool = false
var scanColor: Color = Color(0,1,0)

func _ready():
	var isEnemy = randi_range(1,3)
	if isEnemy <= 2:
		enemy = true
		scanColor = Color(1,0,0)
	
	print(isEnemy)
	
	fishSprite.modulate.r = randf_range(0.25,0.80)
	fishSprite.modulate.g = randf_range(0.25,0.80)
	fishSprite.modulate.b = randf_range(0.25,1)
	
	fishScanSprite.modulate = fishSprite.modulate


func _on_area_entered(area):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(fishSprite, "modulate", scanColor, 0.5)
	tween.parallel().tween_property(fishScanSprite, "modulate", scanColor, 0.5)
