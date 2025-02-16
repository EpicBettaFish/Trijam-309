extends Node2D

#ADJUSTED IN SHOP
var maxScopedMovement: float = 20.0
#END

var scopedIn: bool = false

@onready var sight: Sprite2D = $SightParent/Sight
@onready var sightMask: PointLight2D = $SightParent/Sight/SightMask
@onready var sightParent: Node2D = $SightParent
@onready var sightArea: CollisionShape2D = $SightParent/Sight/SightArea/CollisionShape2D

var scopeStartPos: Vector2

func _ready():
	sightMask.visible = false
	sightArea.disabled = true


func _unhandled_input(event) -> void:
	if event.is_action_pressed("scopeIn"):
		scopeIn()
	if event.is_action_released("scopeIn"):
		scopeOut()
	if event is InputEventMouseMotion:
		sight.global_position = get_global_mouse_position()
		if scopedIn:
			sight.position = sight.position.limit_length(maxScopedMovement)
		else:
			sightParent.global_position = get_global_mouse_position()

func scopeIn() -> void:
	scopedIn = true
	sightMask.visible = scopedIn
	scopeStartPos = get_global_mouse_position()
	sightArea.disabled = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func scopeOut() -> void:
	scopedIn = false
	sightMask.visible = scopedIn
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_viewport().warp_mouse(sight.global_position)
	sightArea.disabled = true
