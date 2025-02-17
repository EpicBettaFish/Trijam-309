extends Node2D

#ADJUSTED IN SHOP
var scanSize: float = 0.25
var gunCooldown: float = 1.0
var scanCooldown: float = 5.0
var scanUptime: float = 2.0
#END

var scopedIn: bool = false
var canScan: bool = true

@onready var sight: Sprite2D = $SightParent/Sight
@onready var sightMask: PointLight2D = $SightParent/Sight/SightMask
@onready var sightParent: Node2D = $SightParent
@onready var sightArea: CollisionShape2D = $SightParent/Sight/SightMask/SightArea/CollisionShape2D

@onready var scanBar: TextureProgressBar = $SightParent/Sight/Scan
@onready var scanCooldownTimer: Timer = $ScanCooldown
@onready var scanActiveTimer: Timer = $ScanActiveTimer

@onready var shootRaycast: RayCast2D = $SightParent/Sight/ShootRaycast

@onready var gunFireSound: AudioStreamPlayer2D = $GunFireSound
@onready var playerAnim: AnimationPlayer = $Player/AnimationPlayer

@onready var scanRefresh: AnimationPlayer = $SightParent/Sight/ScanRefresh/AnimationPlayer

var scopeStartPos: Vector2

var canShoot: bool = true

var cooldownBarTween

func _ready():
	sightMask.visible = false
	sightArea.disabled = true


func _unhandled_input(event) -> void:
	if event.is_action_pressed("scopeIn"):
		if canScan and !scopedIn:
			scopeIn()
	if event.is_action_released("scopeIn"):
		if scopedIn:
			scopeOut()
	if event.is_action_pressed("shoot") and canShoot:
		shoot()
	if event is InputEventMouseMotion:
		if !scopedIn:
			sight.global_position = get_global_mouse_position()
			sightParent.global_position = get_global_mouse_position()

func shoot() -> void:
	if shootRaycast.is_colliding():
		shootRaycast.get_collider().hit()
	playerAnim.play("shoot")
	gunFireSound.play()
	
	canShoot = false
	
	await get_tree().create_timer(gunCooldown).timeout
	
	canShoot = true


func scopeIn() -> void:
	sightMask.scale = Vector2(scanSize, scanSize)
	
	
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
	
	scanActiveTimer.wait_time = scanUptime
	scanActiveTimer.start()


func scopeOut() -> void:
	scanBar.value = 0
	scanActiveTimer.stop()
	sightMask.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	get_viewport().warp_mouse(sight.global_position)
	
	sightArea.disabled = true
	
	scanCooldownTimer.wait_time = scanCooldown
	scanCooldownTimer.start()
	
	if cooldownBarTween:
		cooldownBarTween.kill()
	cooldownBarTween = create_tween().set_trans(Tween.TRANS_LINEAR)
	cooldownBarTween.tween_property(scanBar, "value", 100, 5)
	
	await get_tree().create_timer(0.01).timeout
	scopedIn = false


func _on_scan_cooldown_timeout():
	canScan = true
	scanRefresh.play("refresh")


func _on_scan_active_timer_timeout():
	scopeOut()
