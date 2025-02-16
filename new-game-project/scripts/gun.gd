extends Node2D

#ADJUSTED IN SHOP
var maxScopedMovement: float = 20.0
var scanSize: float = 0.5
#END

var scopedIn: bool = false
var canScan: bool = true

@onready var sight: Sprite2D = $SightParent/Sight
@onready var sightMask: PointLight2D = $SightParent/Sight/SightMask
@onready var sightParent: Node2D = $SightParent
@onready var sightArea: CollisionShape2D = $SightParent/Sight/SightMask/SightArea/CollisionShape2D

@onready var scanBar: TextureProgressBar = $SightParent/Sight/Scan
@onready var scanCooldown: Timer = $ScanCooldown

@onready var shootRaycast: RayCast2D = $SightParent/Sight/ShootRaycast

var scopeStartPos: Vector2

var cooldownBarTween

func _ready():
	sightMask.visible = false
	sightArea.disabled = true


func _unhandled_input(event) -> void:
	if event.is_action_pressed("scopeIn"):
		if canScan:
			scopeIn()
	if event.is_action_released("scopeIn"):
		if scopedIn:
			scopeOut()
	if event.is_action_pressed("shoot"):
		shoot()
	if event is InputEventMouseMotion:
		sight.global_position = get_global_mouse_position()
		if scopedIn:
			sight.position = sight.position.limit_length(maxScopedMovement)
		else:
			sightParent.global_position = get_global_mouse_position()

func shoot() -> void:
	if shootRaycast.is_colliding():
		shootRaycast.get_collider().hit()


func scopeIn() -> void:
	sightMask.scale = Vector2(scanSize, scanSize)
	
	await get_tree().create_timer(0.1).timeout
	
	scopedIn = true
	sightMask.visible = scopedIn
	scopeStartPos = get_global_mouse_position()
	sightArea.disabled = false
	
	canScan = false
	
	if cooldownBarTween:
		cooldownBarTween.kill()
	cooldownBarTween = create_tween().set_trans(Tween.TRANS_CUBIC)
	cooldownBarTween.tween_property(scanBar, "value", 0, 0.3)
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func scopeOut() -> void:
	scopedIn = false
	sightMask.visible = scopedIn
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_viewport().warp_mouse(sight.global_position)
	sightArea.disabled = true
	
	scanCooldown.start()
	
	if cooldownBarTween:
		cooldownBarTween.kill()
	cooldownBarTween = create_tween().set_trans(Tween.TRANS_LINEAR)
	cooldownBarTween.tween_property(scanBar, "value", 100, 3)


func _on_scan_cooldown_timeout():
	canScan = true
