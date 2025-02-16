extends Node2D

var scopedIn: bool = false
@onready var sightMask: Sprite2D = $SightMask
var scopeStartPos: Vector2

func _ready():
	sightMask.visible = false


func _unhandled_input(event) -> void:
	if event.is_action_pressed("scopeIn"):
		scopeIn()
	if event.is_action_released("scopeIn"):
		scopeOut()
	if event is InputEventMouseMotion:
		if scopedIn:
			sightMask.global_position = get_global_mouse_position()
			sightMask.global_position = sightMask.global_position.clamp()

func scopeIn() -> void:
	scopedIn = true
	sightMask.visible = scopedIn
	scopeStartPos = get_global_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func scopeOut() -> void:
	scopedIn = false
	sightMask.visible = scopedIn
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
