extends Node2D

var originalFirerate: float = 2.0
var originalScanUptime: float = 1.0
var originalScanCooldown: float = 5.0

#ADJUSTED IN SHOP
var scanSize: float = 0.5
var gunCooldown: float = 3.0
var scanCooldown: float = 7.5
var scanUptime: float = 1.0
#END

var scopedIn: bool = false
var canScan: bool = true

@onready var boolet_pl = preload("res://scenes/boolet.tscn")
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
	gunCooldown = originalFirerate
	scanUptime = originalScanUptime
	scanCooldown = originalScanCooldown


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
	#bubble particles
	var bullet = boolet_pl.instantiate()
	add_child(bullet)
	bullet.global_position = $GunFireSound.global_position
	bullet.look_at(get_global_mouse_position())
	
	#actual shooting
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
	cooldownBarTween.tween_property(scanBar, "value", 100, scanCooldown)
	
	await get_tree().create_timer(0.01).timeout
	scopedIn = false


func _on_scan_cooldown_timeout():
	canScan = true
	scanRefresh.play("refresh")


func _on_scan_active_timer_timeout():
	scopeOut()


func _on_shop_update_values() -> void:
	gunCooldown = originalFirerate / (1 + (0.15 * Singleton.fire_rate_upgrade))
	scanUptime = originalScanUptime + (0.35 * Singleton.spotter_cooldown_upgrade)
	scanCooldown = originalScanCooldown / (1 + (0.20 * Singleton.scan_cooldown_upgrade))
	
	if Singleton.scan_radius_upgrade:
		scanSize = 0.9
