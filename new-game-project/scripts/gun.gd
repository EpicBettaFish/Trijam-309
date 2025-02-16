extends Node2D

#ADJUSTED IN SHOP
var maxScopedMovement: float = 20.0
#END

var scopedIn: bool = false

@onready var sight: Sprite2D = $SightParent/Sight
@onready var sightMask: PointLight2D = $SightParent/Sight/SightMask
@onready var sightParent: Node2D = $SightParent

var scopeStartPos: Vector2

func _ready():
	sightMask.visible = false


func _unhandled_input(event) -> void:
	if event.is_action_pressed("scopeIn"):
		scopeIn()
	if event.is_action_released("scopeIn"):
		scopeOut()
	if event is InputEventMouseMotion:
		sight.global_position = get_global_mouse_position()
		if scopedIn:
			sight.position = sight.position.limit_length(maxScopedMovement)

func scopeIn() -> void:
	scopedIn = true
	sightMask.visible = scopedIn
	scopeStartPos = get_global_mouse_position()
	sightParent.global_position = scopeStartPos
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func scopeOut() -> void:
	scopedIn = false
	sightMask.visible = scopedIn
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
